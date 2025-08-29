
//
//  TaskManagerApp.swift
//  Task5
//
//  Created by Anas Nasr on 26/08/2025.
//

import SwiftUI
import UserNotifications

@main
struct TaskManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
                .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
                .onAppear {
                    AppDelegate.onTap = { userInfo in
                        print("Tapped notification payload:", userInfo)
                    }
                }
                .task {
                    let settings = await UNUserNotificationCenter.current().notificationSettings()
                    if settings.authorizationStatus == .notDetermined {
                        _ = try? await NotificationManager.shared.requestAuthorization()
                    }
                }  // ✅ Apply theme
        }
    }
}
