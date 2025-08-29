//
//  SettingsViewModel.swift
//  Task5
//
//  Created by Anas Nasr on 29/08/2025.
//

import SwiftUI
import CoreData
import UserNotifications

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    @Published var enableNotifications: Bool = true
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showPermissionAlert: Bool = false
    @Published var notificationStatus: UNAuthorizationStatus = .notDetermined

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        // Load saved dark mode preference
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        checkNotificationPermissions()
    }

    func toggleDarkMode(_ value: Bool) {
        isDarkMode = value
        alertMessage = "Dark Mode \(value ? "Enabled" : "Disabled")"
        showAlert = true
        print("[DEBUG] SettingsViewModel dark mode toggled to: \(value)")
    }

    func toggleNotifications(_ value: Bool) {
        enableNotifications = value
        alertMessage = "Notifications \(value ? "Enabled" : "Disabled")"
        showAlert = true
    }

    // ✅ Check current notification permissions
    func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationStatus = settings.authorizationStatus
            }
        }
    }

    // ✅ Improved delete all tasks with better error handling and UI refresh
    func deleteAllTasks() {
        print("[DEBUG] deleteAllTasks() called")

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            print("[DEBUG] Batch delete result: \(String(describing: result))")

            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: objectIDs
                ]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                print("[DEBUG] MergeChanges executed with \(objectIDs.count) deleted objects")
            }

            try context.save()
            context.reset()
            NotificationCenter.default.post(name: NSNotification.Name("TasksDeleted"), object: nil)
            
            alertMessage = "All tasks deleted successfully!"
            showAlert = true
            print("[DEBUG] All tasks deleted successfully")

        } catch {
            print("[DEBUG] Failed to batch delete: \(error)")
            alertMessage = "Failed to delete all tasks: \(error.localizedDescription)"
            showAlert = true
        }
    }

    // ✅ Enhanced reset permissions with actual functionality
    func resetPermissions() {
        checkNotificationPermissions()
        showPermissionAlert = true
    }
    
    // ✅ Open app settings in iOS Settings app
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            alertMessage = "Unable to open Settings"
            showAlert = true
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url) { success in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.alertMessage = "Settings opened. You can modify permissions there."
                    } else {
                        self?.alertMessage = "Failed to open Settings"
                    }
                    self?.showAlert = true
                }
            }
        }
    }
    
    // ✅ Request notification permissions (useful for first-time setup)
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Permission request failed: \(error.localizedDescription)"
                } else {
                    self?.alertMessage = granted ? "Notifications enabled!" : "Notifications denied. You can change this in Settings."
                }
                self?.showAlert = true
                self?.checkNotificationPermissions()
            }
        }
    }
    
    // ✅ Get user-friendly permission status
    var permissionStatusText: String {
        switch notificationStatus {
        case .notDetermined:
            return "Not Set"
        case .denied:
            return "Denied"
        case .authorized:
            return "Allowed"
        case .provisional:
            return "Provisional"
        case .ephemeral:
            return "Ephemeral"
        @unknown default:
            return "Unknown"
        }
    }
    
    // ✅ Check if permissions need attention
    var needsPermissionUpdate: Bool {
        return notificationStatus == .denied || notificationStatus == .notDetermined
    }
}
