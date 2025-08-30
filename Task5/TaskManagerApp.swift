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

    // Your existing state
    @State private var selectedTab = 0
    @State private var mapCityName: String = ""

    // Dark mode settings
    @StateObject private var appSettings = AppSettings()

    // Splash control
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)

                // Splash overlay
                .overlay {
                    if showSplash {
                        SplashView(isActive: $showSplash)
                            .transition(.opacity)
                    }
                }

                .onAppear {
                    // Handle notification taps (route if you want using userInfo)
                    AppDelegate.onTap = { userInfo in
                        print("Tapped notification payload:", userInfo)
                        // Example (uncomment if MainTabView exposes selection):
                        // if let route = userInfo["route"] as? String, route == "map" { selectedTab = 1 }
                    }
                }

                .task {
                    // Ask for notification permission once
                    let settings = await UNUserNotificationCenter.current().notificationSettings()
                    if settings.authorizationStatus == .notDetermined {
                        _ = try? await NotificationManager.shared.requestAuthorization()
                    }
                }
        }
    }
}

