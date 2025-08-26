//
//  MainTabView.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var mapCityName: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab, mapCityName: $mapCityName)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            MapView(cityName: mapCityName.isEmpty ? nil : mapCityName)
                .tabItem {
                    Label("Maps", systemImage: "map.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
