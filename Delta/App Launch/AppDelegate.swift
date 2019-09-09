import UIKit
import CoreData
import UserNotifications

import DeltaCore
import GBADeltaCore
import GBCDeltaCore
import SNESDeltaCore
import NESDeltaCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerDeltaCores()
        registerLocalNotifications()

        return true
    }
    
    func registerDeltaCores() {
        Delta.register(GBA.core)
        Delta.register(GBC.core)
        Delta.register(SNES.core)
        Delta.register(NES.core)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Games")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        QuickActionsStore.shared.fetch()
        UIApplication.shared.shortcutItems = QuickActionsStore.shared.games.map { game in
            return UIApplicationShortcutItem(type: "FavoriteAction",
                                             localizedTitle: game.splitTitle.0 ?? game.title!,
                                             localizedSubtitle: game.splitTitle.1,
                                             icon: .init(systemImageName: "play.fill"),
                                             userInfo: ["id": game.id! as NSSecureCoding])
        }
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerLocalNotifications() {
        let current = NotificationStore.shared.notificationCenter
        current.delegate = self
        current.requestAuthorization(options: [.alert, .sound, .badge]) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert]) // we don't want sounds n shit
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // todo: migrate to actions
        // TODO: DRY
        if let id = response.notification.request.content.userInfo["id"] as? String {
            let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            request.predicate = NSPredicate(format: "id = %@", id)
            request.fetchLimit = 1
            guard let games = try? persistentContainer.viewContext.fetch(request), let game = games.first else {
                return
            }
            ActionCreator().presentEmulator(game)()
        }
    }
}

extension AppDelegate {
    func sync() {
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey
            .managedObjectContext] = self.persistentContainer.viewContext
        
        guard let filePath = Bundle.main.url(forResource: "all", withExtension: "json") else {return}
        guard let data = try? Data(contentsOf: filePath) else {return}
        let _ = try? decoder.decode(SearchResults.self, from: data)

        self.saveContext()
    }
}
