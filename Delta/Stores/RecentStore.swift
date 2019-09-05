import SwiftUI

class RecentStore: ObservableObject {
    @Published var entries = [String]()
    
    func save(_ searchTerm: String) {
        entries = NSSet(array: [searchTerm] + entries).allObjects as? [String] ?? []
        
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.set(self.entries, forKey: "entries")
        }
    }
    
    func clear() {
        entries = []
        UserDefaults.standard.removeObject(forKey: "entries")
    }
    
    init() {
        entries = UserDefaults.standard.array(forKey: "entries") as? [String] ?? []
    }
}
