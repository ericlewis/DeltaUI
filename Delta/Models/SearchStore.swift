import SwiftUI
import DeltaCore
import Combine
import CoreData

class SearchStore: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var searchTerm = "" {
        didSet {
            search()
        }
    }
    
    @Published var scope: Int = 0 {
        didSet {
            search()
        }
    }
    
    @Published var fetchRequest: NSFetchRequest<GameEntity>? = nil

    @Published var games: [GameEntity] = []
    var console: Console

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<GameEntity> = {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest() as! NSFetchRequest<GameEntity>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        if scope == 0 {
            let predicate = NSPredicate(format: "type = %@ && romName != nil", console.rawValue)
            fetchRequest.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "type = %@", console.rawValue)
            fetchRequest.predicate = predicate
        }
                
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: "type",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    func search() {
        if !searchTerm.isEmpty {
            if scope == 0 {
                let predicate = NSPredicate(format: "title contains[cd] %@ && type = %@ && romName != nil", "\(searchTerm)", console.rawValue)
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "title contains[cd] %@ && type = %@", "\(searchTerm)", console.rawValue)
                self.fetchedResultsController.fetchRequest.predicate = predicate
            }
        } else {
            if scope == 0 {
                let predicate = NSPredicate(format: "type = %@ && romName != nil", console.rawValue)
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "type = %@", console.rawValue)
                self.fetchedResultsController.fetchRequest.predicate = predicate
            }
        }
        
        try? self.fetchedResultsController.performFetch()
        self.games = self.fetchedResultsController.fetchedObjects ?? []
        self.fetchRequest = self.fetchedResultsController.fetchRequest
    }
    
    private var cancellable: AnyCancellable? = nil
    
    init(console: Console) {
        self.console = console
        super.init()

        cancellable = AnyCancellable($searchTerm
             .removeDuplicates()
             .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .sink { _ in self.search() })
    }
}
