import Foundation

extension UserDefaults {
    func set(_ value: Bool, forKey key: SettingsKey) {
        self.set(value, forKey: key.rawValue)
    }
    
    func bool(forKey key: SettingsKey, defaultValue: Bool) -> Bool {
        self.object(forKey: key.rawValue) != nil ? self.bool(forKey: key.rawValue) : defaultValue
    }
}

@propertyWrapper
class PublishedSetting {
    @Published
    var wrappedValue: Bool {
        didSet {
            UserDefaults.standard.set(self.wrappedValue, forKey: key)
        }
    }
    
    private var key: SettingsKey

    init(wrappedValue value: Bool, key: SettingsKey) {
        self.wrappedValue = UserDefaults.standard.bool(forKey: key, defaultValue: value)
        self.key = key
    }
}
