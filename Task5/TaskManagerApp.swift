import SwiftUI
import UserNotifications

@main
struct TaskManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
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
                }
        }
    }
}
