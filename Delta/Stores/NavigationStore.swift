import SwiftUI
import DeltaCore

enum Tabs: Int {
    case library, forYou, browse, search, settings
}

enum NavigationActions {
    case updateSelectedTab(Int)
    case showSheet(Sheets)
    case showActionSheet(ActionSheets)
    case showEmulatorMenu
    case dismissSheet
}

extension ActionCreator where Actions == NavigationActions {
    func presentEmulator(_ game: ItemEntity) {
        perform(.showSheet(.emulator(game)))
    }
    
    func presentEmulator(_ game: ItemEntity) -> () -> Void {
        {
            self.presentEmulator(game)
        }
    }
    
    func presentSavedStates(_ game: ItemEntity) {
        self.perform(.showSheet(.saveStates(game)))
    }
    
    func presentSavedStates(_ game: ItemEntity) -> () -> Void {
        {
            self.presentSavedStates(game)
        }
    }
    
    func presentAddToPlaylist(_ game: ItemEntity) {
        self.perform(.showSheet(.addToPlaylist(game)))
    }
    
    func presentAddToPlaylist(_ game: ItemEntity) -> () -> Void {
        {
            self.presentAddToPlaylist(game)
        }
    }
    
    func presentLookup(_ game: ItemEntity) -> () -> Void {
        {
            self.perform(.showSheet(.lookup(game)))
        }
    }
    
    func dismiss() {
        perform(.dismissSheet)
    }
    
    func switchTab(to tab: Tabs) {
        perform(.updateSelectedTab(tab.rawValue))
    }
    
    func presentMenu() {
        perform(.showEmulatorMenu)
    }
    
    func presentRemoveFromLibraryConfirmation(_ game: ItemEntity) -> () -> Void {
        {
            self.perform(.showActionSheet(.removeFromLibraryConfirmation(game)))
        }
    }
    
    func presentRemoveSaveFromLibraryConfirmation(_ save: SaveEntity) -> () -> Void {
        {
            self.perform(.showActionSheet(.removeSaveFromLibraryConfirmation(save)))
        }
    }
}

enum Sheets: Identifiable {
    case none
    case saveStates(ItemEntity)
    case addToPlaylist(ItemEntity)
    case emulator(ItemEntity)
    case lookup(ItemEntity)

    var id: String {
        switch self {
        case .none: return "none"
        case .saveStates: return "saveStates"
        case .addToPlaylist: return "addToPlaylist"
        case .emulator: return "emulator"
        case .lookup: return "lookup"
        }
    }
}

enum ActionSheets: Identifiable {
    case none
    case removeFromLibraryConfirmation(ItemEntity)
    case removeSaveFromLibraryConfirmation(SaveEntity)

    var id: String {
        switch self {
        case .none: return "none"
        case .removeFromLibraryConfirmation: return "removeFromLibraryConfirmation"
        case .removeSaveFromLibraryConfirmation: return "removeSaveFromLibraryConfirmation"
        }
    }
}

class NavigationStore: ObservableObject {
    static let shared = NavigationStore()
    
    @Published var selectedTab = 0 {
        didSet {
            persist()
        }
    }
    
    @Published var activeSheet: Sheets?
    @Published var activeSheetLayer2: Sheets?
    @Published var activeActionSheet: ActionSheets?
    @Published var currentGame: ItemEntity?
    @Published var isShowingEmulatorMenu = false

    init(dispatcher: Dispatcher<NavigationActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .updateSelectedTab(let tab): self.selectedTab = tab
            case .showSheet(let sheet):
                switch sheet {
                case .emulator(let game):
                    if game.isDownloaded == true {
                      game.updateLastPlayed()
                      self.currentGame = game
                      self.activeSheet = sheet
                    }
                default:
                    if self.activeSheet == nil {
                        self.activeSheet = sheet
                    } else {
                        self.activeSheetLayer2 = sheet
                    }
                }
            case .showActionSheet(let sheet): self.activeActionSheet = sheet
            case .showEmulatorMenu:
                self.isShowingEmulatorMenu = true
            case .dismissSheet:
                if self.activeSheetLayer2 == nil {
                    self.activeSheet = nil
                } else {
                    self.activeSheetLayer2 = nil
                }
            }
            
            self.persist()
        }
        
        hydrate()
    }
    
    private func hydrate() {
        selectedTab = UserDefaults.standard.integer(forKey: "tab")
    }
    
    private func persist() {
        UserDefaults.standard.set(self.selectedTab, forKey: "tab")
    }
}

extension NavigationStore {
    func handleDeeplink(_ deeplink: Deeplink) {
        switch deeplink {
        case .url(_):
            print("TODO")
        case .shortcut(let shortcut):
            print(shortcut)
        }
    }
}

enum Deeplink {
    case url(URL), shortcut(UIApplicationShortcutItem)
    
    enum Action {
        case launchGame(String)
        
        var type: String {
            switch self {
            case .launchGame(_):
                return "launchGame"
            }
        }
        
        var key: String {
            switch self {
            case .launchGame(_):
                return "launchGame"
            }
        }
    }
}

extension UIApplicationShortcutItem {
    convenience init(_ localizedTitle: String, action: Deeplink.Action) {
        var userInfo: [String: NSSecureCoding]?

        switch action {
        case .launchGame(let identifier):
            userInfo = [action.type: identifier as NSString]
        }
        
        self.init(type: action.type, localizedTitle: localizedTitle, localizedSubtitle: nil, icon: nil, userInfo: userInfo)
    }
}
