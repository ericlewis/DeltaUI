import SwiftUI
import UserNotifications
import MobileCoreServices

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
        
        let nakedRequest = UNNotificationRequest(identifier: id,
                                                content: content,
                                                trigger: nil)
        
        guard let url = game.image else { return nakedRequest }
        guard let imageData = NSData(contentsOf: url) else { return nakedRequest }
        guard let attachment = UNNotificationAttachment.create("image.png", data: imageData) else { return nakedRequest }
        
        content.attachments = [attachment]
        
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
        content.attachments = [try! UNNotificationAttachment(identifier: "image.png", url: imageURL, options: [UNNotificationAttachmentOptionsTypeHintKey: kUTTypePNG])]
        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        
        return request
    }
}

// LIFTED FROM SO, probably need to change
extension UNNotificationAttachment {

    /// Save the image to disk
    static func create(_ imageFileIdentifier: String, data: NSData) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)

        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL!, options: [])
            let imageAttachment = try UNNotificationAttachment(identifier: imageFileIdentifier, url: fileURL!, options: [UNNotificationAttachmentOptionsTypeHintKey: kUTTypeJPEG])
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }

        return nil
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
        if SettingsStore.shared.notificationsEnabled {
            switch notification {
            case .downloadComplete(let game):
                notificationCenter.add(.downloadComplete(game))
            case .saveCompelete(let game, let imageURL):
                notificationCenter.add(.saveComplete(game, imageURL))
            }
        }
    }
}
