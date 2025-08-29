import SwiftUI
import UserNotifications

struct NotficationDemoView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Notifications Demo").font(.title2).bold()

            
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    print("Permission granted: \(granted)")
                    if let error = error { print("Request failed: \(error)") }
                }
            }

            Button("Schedule in 5 seconds") {
                let content = UNMutableNotificationContent()
                content.title = "Task Reminder"
                content.body = "Tap to open the app"
                content.sound = .default
                content.userInfo = ["route": "tasks"]

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error { print("Schedule error: \(error)") }
                }
            }

            Button("Schedule Daily at 9:00") {
                var comps = DateComponents(); comps.hour = 9; comps.minute = 0
                let content = UNMutableNotificationContent()
                content.title = "Morning Review"
                content.body = "Check your tasks for today"
                content.sound = .default
                content.userInfo = ["route": "tasks"]

                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error { print("Schedule error: \(error)") }
                }
            }
        }
        .padding()
    }
}

