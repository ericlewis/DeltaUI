import SwiftUI
import CoreData

class QuickActionsStore {
    static let shared = QuickActionsStore()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<GameEntity> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: FetchRequests.recentlyPlayed(console: .all, limit: 3),
                                                                  managedObjectContext: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    var games: [GameEntity] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    init() {
        try? fetchedResultsController.performFetch()
    }
    
    func fetch() {
        try? fetchedResultsController.performFetch()
    }
}
