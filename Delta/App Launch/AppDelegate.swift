import UIKit
import CoreData

import DeltaCore
import GBADeltaCore
import GBCDeltaCore
import SNESDeltaCore
import NESDeltaCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDeltaCores()
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

extension AppDelegate {
    func sync() {
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey
            .managedObjectContext] = self.persistentContainer.viewContext
        
        guard let filePath = Bundle.main.url(forResource: "all", withExtension: "json") else {return}
        guard let data = try? Data(contentsOf: filePath) else {return}
        let _ = try? decoder.decode([GameEntity].self, from: data)

        self.saveContext()
    }
}
