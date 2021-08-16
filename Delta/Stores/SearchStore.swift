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
    
    @Published var fetchRequest: NSFetchRequest<ItemEntity>? = nil
    
    @Published var gba: [ItemEntity] = []
    @Published var gbc: [ItemEntity] = []
    @Published var gb: [ItemEntity] = []
    @Published var snes: [ItemEntity] = []
    @Published var nes: [ItemEntity] = []

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ItemEntity> = {
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "systemShort", ascending: true), NSSortDescriptor(key: "title", ascending: true)]
        
        if scope == 0 {
            let predicate = NSPredicate(format: "rom != nil")
            fetchRequest.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "rom == nil")
            fetchRequest.predicate = predicate
        }
                
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: "systemShort",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    func search() {
        if !searchTerm.isEmpty {
            if scope == 0 {
                let predicate = NSPredicate(format: "title contains[cd] %@ && rom != nil", "\(searchTerm)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "title contains[cd] %@ && rom == nil", "\(searchTerm)")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            }
        } else {
            if scope == 0 {
                let predicate = NSPredicate(format: "rom != nil")
                self.fetchedResultsController.fetchRequest.predicate = predicate
            } else {
                let predicate = NSPredicate(format: "rom == nil")
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
            case "GB":
            self.gb = (section.objects as? [ItemEntity])?.prefix(limit).asArray() ?? []
            case "GBC":
            self.gbc = (section.objects as? [ItemEntity])?.prefix(limit).asArray() ?? []
            case "GBA":
            self.gba = (section.objects as? [ItemEntity])?.prefix(limit).asArray() ?? []
            case "NES":
            self.nes = (section.objects as? [ItemEntity])?.prefix(limit).asArray() ?? []
            case "SNES":
            self.snes = (section.objects as? [ItemEntity])?.prefix(limit).asArray() ?? []
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
