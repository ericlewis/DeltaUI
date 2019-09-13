import SwiftUI
import CoreData

class QuickActionsStore {
    static let shared = QuickActionsStore()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ItemEntity> = {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: FetchRequests.recentlyPlayed(console: .all, limit: 3),
                                                                  managedObjectContext: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    var games: [ItemEntity] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    init() {
        try? fetchedResultsController.performFetch()
    }
    
    func fetch() {
        try? fetchedResultsController.performFetch()
    }
}
