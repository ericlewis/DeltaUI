import SwiftUI

enum SaveStateActions {
    case load(GameEntity)
    case delete(SaveStateEntity)
}

extension ActionCreator where Actions == SaveStateActions {
    func loadSaveStates(_ game: GameEntity) {
        perform(.load(game))
    }
    
    func deleteSaveState(_ save: SaveStateEntity) {
        perform(.delete(save))
    }
}

class SaveStatesStore: ObservableObject {
    static let shared = SaveStatesStore()
    
    @Published var autoSave: SaveStateEntity?
    @Published var saves: [SaveStateEntity] = []

    init(dispatcher: Dispatcher<SaveStateActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .load(let game):
                self.autoSave = game.saveState
                self.saves = game.saveStates?.allObjects as? [SaveStateEntity] ?? []
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
