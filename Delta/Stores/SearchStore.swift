import SwiftUI
import DeltaCore
import Combine
import CoreData

extension Collection {
    func asArray() -> Array<Element> {
        Array(self)
    }
}

class SearchStore: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var searchTerm = ""
    @Published var scope: Int = 0
    
    @Published var fetchRequest: NSFetchRequest<GameEntity>? = nil    
    
    @Published var gba: [GameEntity] = []
    @Published var gbc: [GameEntity] = []
    @Published var gb: [GameEntity] = []
    @Published var snes: [GameEntity] = []
    @Published var nes: [GameEntity] = []

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<GameEntity> = {
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true), NSSortDescriptor(key: "title", ascending: true)]
        
        if scope == 0 {
            let predicate = NSPredicate(format: "gameURL != nil")
            fetchRequest.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "gameURL == nil")
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
                let predicate = NSPredicate(format: "title contains[cd] %@ && gameURL != nil", "\(searchTerm)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "title contains[cd] %@ && gameURL == nil", "\(searchTerm)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            }
        } else {
            if scope == 0 {
                let predicate = NSPredicate(format: "gameURL != nil")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "gameURL == nil")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            }
        }
        
        try? self.fetchedResultsController.performFetch()
        self.fetchRequest = self.fetchedResultsController.fetchRequest
        
        let limit = 6
        
        self.gb = []
        self.gbc = []
        self.gba = []
        self.nes = []
        self.snes = []
                
        self.fetchedResultsController.sections?.forEach { section in
            switch section.name {
            case "gameboy":
            self.gb = (section.objects as? [GameEntity])?.prefix(limit).asArray() ?? []
            case "gameboy-color":
            self.gbc = (section.objects as? [GameEntity])?.prefix(limit).asArray() ?? []
            case "gameboy-advance":
            self.gba = (section.objects as? [GameEntity])?.prefix(limit).asArray() ?? []
            case "nintendo":
            self.nes = (section.objects as? [GameEntity])?.prefix(limit).asArray() ?? []
            case "super-nintendo":
            self.snes = (section.objects as? [GameEntity])?.prefix(limit).asArray() ?? []
            default:
                break
            }
        }
    }
    
    private var cancellable: AnyCancellable? = nil
    
    override init() {
        super.init()

        cancellable = AnyCancellable($searchTerm
             .removeDuplicates()
             .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { _ in self.search() })
        
        let _ = AnyCancellable($scope
         .removeDuplicates()
         .debounce(for: 0.1, scheduler: DispatchQueue.main)
        .sink { _ in self.search() })
    }
}
