import SwiftUI
import Combine

var singletons_store: [String: AnyObject] = [:]

class Dispatcher<Actions> {
    class var shared: Dispatcher<Actions> {
        let store_key = String(describing: Actions.self)
        if let singleton = singletons_store[store_key] {
            return singleton as! Dispatcher<Actions>
        } else {
            let new_singleton = Dispatcher<Actions>()
            singletons_store[store_key] = new_singleton
            return new_singleton
        }
    }
    
    private let actionSubject = PassthroughSubject<Actions, Never>()
    private var cancellables: [AnyCancellable] = []

    func register(callback: @escaping (Actions) -> ()) {
        let actionStream = actionSubject.sink(receiveValue: callback)
        cancellables += [actionStream]
    }
    
    func dispatch(_ action: Actions) {
        actionSubject.send(action)
    }
}

