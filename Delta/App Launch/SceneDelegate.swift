import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
                
        let contentView = RootView()
                            .accentColor(.purple)
                            .environment(\.managedObjectContext, context)
                            .environmentObject(NavigationStore.shared)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let gameInfo = shortcutItem.userInfo as? [String: String], let id = gameInfo["id"] else {
            return completionHandler(true)
        }
        
        // TODO: DRY
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = NSPredicate(format: "id = %@", id)
        request.fetchLimit = 1
        guard let games = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(request), let game = games.first else {
            return
        }
        // TODO
//        ActionCreator().presentEmulator(game)()
        completionHandler(false)
    }
}

