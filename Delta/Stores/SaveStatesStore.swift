import SwiftUI

enum SaveStateActions {
    case load(ItemEntity)
    case delete(SaveEntity)
}

extension ActionCreator where Actions == SaveStateActions {
    func loadSaveStates(_ game: ItemEntity) {
        perform(.load(game))
    }
    
    func deleteSaveState(_ save: SaveEntity) {
        perform(.delete(save))
    }
}

class SaveStatesStore: ObservableObject {
    static let shared = SaveStatesStore()
    
    @Published var autoSave: SaveEntity?
    @Published var saves: [SaveEntity] = []

    init(dispatcher: Dispatcher<SaveStateActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .load(let game):
                // TODO:
//                self.autoSave = game.saves?.first
                self.saves = game.saves?.allObjects as? [SaveEntity] ?? []
            case .delete(let save):
                let idx = self.saves.firstIndex {
                    $0 == save
                } ?? 0
                
                self.saves.remove(at: idx)
                save.managedObjectContext?.delete(save)
                try? save.managedObjectContext?.save()
            }
        }
    }
}
