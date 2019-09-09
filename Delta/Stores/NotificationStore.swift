import SwiftUI
import UserNotifications

extension UNUserNotificationCenter {
    func add(_ request: UNNotificationRequest) {
        add(request, withCompletionHandler: nil)
    }
}

extension UNNotificationRequest {
    static func downloadComplete(_ game: GameEntity) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        let id = game.id! + "-download"
        
        content.title = "Download Finished"
        content.body = "\(game.title ?? "No Title") is ready to play"
        content.userInfo = ["id": game.id!]
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: nil)
        
        return request
    }
    
    static func saveComplete(_ game: GameEntity, _ imageURL: URL) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        
        let id = game.id! + "-save"
        
        content.title = "Save Successful"
        content.body = "\(game.title ?? "No Title") - \(game.console.title)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        
        return request
    }
}

enum LocalNotification {
    case downloadComplete(GameEntity)
    case saveCompelete(GameEntity, URL)
}

enum NotificationActions {
    case requestPermissions
    case showNotification(LocalNotification)
}

extension ActionCreator where Actions == NotificationActions {
    func requestPermissions() {
        perform(.requestPermissions)
    }
    
    func downloadComplete(_ game: GameEntity) {
        perform(.showNotification(.downloadComplete(game)))
    }
    
    func saveComplete(_ game: GameEntity, _ imageURL: URL) {
        perform(.showNotification(.saveCompelete(game, imageURL)))
    }
}

class NotificationStore: ObservableObject {
    static let NotificationsEnabledKey = "NotificationStore_NotificationsEnabledKey"
    static let shared = NotificationStore()
    
    var notificationCenter: UNUserNotificationCenter
    
    init(dispatcher: Dispatcher<NotificationActions> = .shared, notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
        
        dispatcher.register { action in
            switch action {
            case .requestPermissions:
                self.requestPermissions()
            case .showNotification(let notification):
                self.showNotification(notification)
            }
        }
    }
}

extension NotificationStore {
    private func requestPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    private func showNotification(_ notification: LocalNotification) {
        switch notification {
        case .downloadComplete(let game):
            notificationCenter.add(.downloadComplete(game))
        case .saveCompelete(let game, let imageURL):
            notificationCenter.add(.saveComplete(game, imageURL))
        }
    }
}
