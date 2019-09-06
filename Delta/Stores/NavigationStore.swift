import SwiftUI

class NavigationStore: ObservableObject {
    @Published var selectedTab = 0 {
        didSet {
            UserDefaults.standard.set(self.selectedTab, forKey: "tab")
        }
    }
    
    init() {
        selectedTab = UserDefaults.standard.integer(forKey: "tab")
    }
}
