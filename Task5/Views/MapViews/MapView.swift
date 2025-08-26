import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var cityName: String? = nil
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @StateObject private var locationManager = LocationManager()
    @State private var annotations: [CityAnnotation] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for a city", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button(action: {
                        searchCity(searchText)
                    }) {
                        Text("Search")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(isLoading || searchText.isEmpty)
                }
                .padding(.top)
                
                if let cityName = cityName, !cityName.isEmpty {
                    Text(cityName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: true, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                                .background(Circle().fill(.white).frame(width: 35, height: 35))
                            Text(annotation.title ?? "City not found")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(.white.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .ignoresSafeArea()
                .overlay(
                    isLoading ? ProgressView("Searching...").progressViewStyle(.circular) : nil
                )
            }
            .navigationTitle("Map")
            .onAppear {
                if let cityName = cityName, !cityName.isEmpty && cityName != "Unknown" && cityName != "No city entered" {
                    searchText = cityName
                    searchCity(cityName)
                } else {
                    locationManager.requestLocation()
                    if let userLocation = locationManager.location {
                        region.center = userLocation
                        let annotation = CityAnnotation(
                            id: UUID().uuidString,
                            coordinate: userLocation,
                            title: "Your Location"
                        )
                        annotations = [annotation]
                    }
                }
            }
        }
    }
    
    private func searchCity(_ name: String) {
        isLoading = true
        errorMessage = nil
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            defer { isLoading = false }
            
            if let error = error {
                errorMessage = "Failed to find city: \(error.localizedDescription)"
                return
            }
            
            guard let placemark = placemarks?.first,
                  let coordinate = placemark.location?.coordinate else {
                errorMessage = "City not found. Try a different name."
                return
            }
            
            withAnimation {
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                let newAnnotation = CityAnnotation(
                    id: UUID().uuidString,
                    coordinate: coordinate,
                    title: name
                )
                annotations = [newAnnotation]
            }
        }
    }
}

struct CityAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String?
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(cityName: "New York")
    }
}
