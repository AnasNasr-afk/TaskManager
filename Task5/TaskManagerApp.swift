
//
//  TaskManagerApp.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedTab = 0
    @State private var mapCityName: String = ""
    
    // ✅ Add AppSettings for dark mode functionality
    @StateObject private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appSettings)  // ✅ Inject AppSettings
                .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)  // ✅ Apply theme
        }
    }
}
