import SwiftUI

enum EmulatorActions {
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
}

class EmulatorStore: ObservableObject {
    static let shared = EmulatorStore()
    
    var save: (() -> Void)?
    var load: ((SaveStateEntity) -> Void)?
                
    init(dispatcher: Dispatcher<EmulatorActions> = .shared) {
        dispatcher.register { [weak self] action in
            switch action {
            case .loadState(let state):
                self?.load?(state)
            case .saveState:
                self?.save?()
            }
        }
    }
}
