import Foundation

class ActionCreator<Actions> {
    private let dispatcher: Dispatcher<Actions>
    
    init(dispatcher: Dispatcher<Actions> = .shared) {
        self.dispatcher = dispatcher
    }
    
    func perform(_ action: Actions) {
        DispatchQueue.main.async {
            self.dispatcher.dispatch(action)
        }
    }
}
