import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    @discardableResult
    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound])
    }

    func scheduleIn(seconds: TimeInterval,
                    title: String,
                    body: String,
                    userInfo: [AnyHashable: Any] = [:]) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = userInfo

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(req)
    }

    func scheduleDaily(hour: Int, minute: Int,
                       title: String, body: String,
                       userInfo: [AnyHashable: Any] = [:]) async throws {
        var comps = DateComponents(); comps.hour = hour; comps.minute = minute

        let content = UNMutableNotificationContent()
        content.title = title; content.body = body; content.sound = .default; content.userInfo = userInfo

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(req)
    }
}
