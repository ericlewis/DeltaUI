import SwiftUI

enum EmulatorActions {
    case toggleFavorite(GameEntity)
    case loadState(SaveStateEntity)
    case saveState
}

extension ActionCreator where Actions == EmulatorActions {
    func loadState(_ save: SaveStateEntity) {
        perform(.loadState(save))
    }
    
    func saveState() {
        perform(.saveState)
    }
    
    func toggleFavorite(_ game: GameEntity) {
        perform(.toggleFavorite(game))
    }
}

class EmulatorStore: ObservableObject {
    static let shared = EmulatorStore()
    
    var save: (() -> Void)?
    var load: ((SaveStateEntity) -> Void)?
                
    init(dispatcher: Dispatcher<EmulatorActions> = .shared) {
        dispatcher.register { [weak self] action in
            switch action {
            case .toggleFavorite(let game):
                game.favorited.toggle()
                try? game.managedObjectContext?.save()
            case .loadState(let state):
                self?.load?(state)
            case .saveState:
                self?.save?()
            }
        }
    }
}
