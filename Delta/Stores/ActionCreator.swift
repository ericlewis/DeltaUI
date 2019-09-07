import Foundation

class ActionCreator<Actions> {
    private let dispatcher: Dispatcher<Actions>
    
    init(dispatcher: Dispatcher<Actions> = .shared) {
        self.dispatcher = dispatcher
    }
    
    func perform(_ action: Actions) {
        dispatcher.dispatch(action)
    }
    
    func perform(_ actions: [Actions]) {
        actions.forEach {
            self.dispatcher.dispatch($0)
        }
    }
}
