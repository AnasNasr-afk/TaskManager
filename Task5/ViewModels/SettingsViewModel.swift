//
//  SettingsViewModel.swift
//  Task5
//
//  Created by Anas Nasr on 27/08/2025.
//
import SwiftUI
import UserNotifications

class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode = false
    @Published var enableNotifications = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let notificationDelegate = NotificationDelegate()
    
    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    func toggleDarkMode(_ value: Bool) {
        alertMessage = value ? "Dark Mode Enabled " : "Dark Mode Disabled "
        showAlert = true
    }
    
    func toggleNotifications(_ value: Bool) {
        if value {
            requestNotificationPermission()
        } else {
            alertMessage = "Notifications Disabled "
            showAlert = true
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.alertMessage = "Notifications Enabled "
                    self.showAlert = true
                    self.scheduleTestNotification()
                } else {
                    self.alertMessage = "Permission Denied "
                    self.showAlert = true
                }
            }
        }
    }
    
    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello "
        content.body = "This is a test notification."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
