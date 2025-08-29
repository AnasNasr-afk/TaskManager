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
    
    // Get the managed object context from the environment
    @Environment(\.managedObjectContext) private var viewContext
    // ✅ Get app settings for dark mode
    @EnvironmentObject private var appSettings: AppSettings
    
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

            // ✅ Fixed: Pass the actual context and app settings
            SettingsView(context: viewContext, appSettings: appSettings)
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
        .environmentObject(AppSettings())
}
