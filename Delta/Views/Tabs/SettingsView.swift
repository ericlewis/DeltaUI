import SwiftUI

enum SettingsKey: String {
    case swipeToDismiss
}

extension UserDefaults {
    func set(_ value: Bool, forKey key: SettingsKey) {
        self.set(value, forKey: key.rawValue)
    }
    
    func bool(forKey key: SettingsKey, defaultValue: Bool) -> Bool {
        self.object(forKey: key.rawValue) != nil ? self.bool(forKey: key.rawValue) : defaultValue
    }
}

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()
    
    let defaults = UserDefaults.standard
    
    @Published var swipeToDismiss = true {
        didSet {
            defaults.set(self.swipeToDismiss, forKey: .swipeToDismiss)
        }
    }
    
    init() {
        hydrate()
    }
    
    private func hydrate() {
        swipeToDismiss = defaults.bool(forKey: .swipeToDismiss, defaultValue: true)
    }
}

struct SettingsView: View {
    @ObservedObject var settings = SettingsStore.shared
    
    var body: some View {
        Form {
            Toggle(isOn: $settings.swipeToDismiss) {
                Text("Swipe to Dismiss Emulator")
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
