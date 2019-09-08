import SwiftUI

enum RecentsActions {
    case load
    case clear
    case save(String)
}

extension ActionCreator where Actions == RecentsActions {
    func save(searchTerm: String) {
        perform(.save(searchTerm))
    }
    
    func clearRecentSearches() {
        perform(.clear)
    }
    
    func loadRecentSearches() {
        perform(.load)
    }
}

class RecentsStore: ObservableObject {
    static let shared = RecentsStore()

    @Published var entries = [String]()

    init(dispatcher: Dispatcher<RecentsActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .save(let searchTerm):
                self.entries = NSSet(array: [searchTerm] + self.entries).allObjects as? [String] ?? []
                UserDefaults.standard.set(self.entries, forKey: "entries")
            case .clear:
                self.entries = []
                UserDefaults.standard.removeObject(forKey: "entries")
            case .load:
                self.entries = UserDefaults.standard.array(forKey: "entries") as? [String] ?? []
            }
        }
    }
}
