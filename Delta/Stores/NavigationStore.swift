import SwiftUI

enum Tabs: Int {
    case library, forYou, browse, search, settings
}

enum NavigationActions {
    case updateSelectedTab(Int)
    case showSheet(Sheets)
    case showActionSheet(ActionSheets)
    case dismissSheet
}

extension ActionCreator where Actions == NavigationActions {
    func presentEmulator(_ game: GameEntity) {
        perform(.showSheet(.emulator(game)))
    }
    
    func presentEmulator(_ game: GameEntity) -> () -> Void {
        {
            self.presentEmulator(game)
        }
    }
    
    func presentSavedStates(_ game: GameEntity) {
        self.perform(.showSheet(.saveStates(game)))
    }
    
    func presentSavedStates(_ game: GameEntity) -> () -> Void {
        {
            self.presentSavedStates(game)
        }
    }
    
    func presentAddToPlaylist(_ game: GameEntity) {
        self.perform(.showSheet(.addToPlaylist(game)))
    }
    
    func presentAddToPlaylist(_ game: GameEntity) -> () -> Void {
        {
            self.presentAddToPlaylist(game)
        }
    }
    
    func presentLookup(_ game: GameEntity) -> () -> Void {
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
        perform(.showActionSheet(.emulatorMenu))
    }
    
    func presentRemoveFromLibraryConfirmation(_ game: GameEntity) -> () -> Void {
        {
            self.perform(.showActionSheet(.removeFromLibraryConfirmation(game)))
        }
    }
}

enum Sheets: Identifiable {
    case none
    case saveStates(GameEntity)
    case addToPlaylist(GameEntity)
    case emulator(GameEntity)
    case lookup(GameEntity)

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
    case removeFromLibraryConfirmation(GameEntity)
    case emulatorMenu
    
    var id: String {
        switch self {
        case .none: return "none"
        case .removeFromLibraryConfirmation: return "removeFromLibraryConfirmation"
        case .emulatorMenu: return "emulatorMenu"
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
    @Published var currentGame: GameEntity?

    init(dispatcher: Dispatcher<NavigationActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .updateSelectedTab(let tab): self.selectedTab = tab
            case .showSheet(let sheet):
                switch sheet {
                case .emulator(let game):
                    if game.hasROM {
                      game.updateLastPlayed()
                      self.currentGame = game
                      self.activeSheet = sheet
                    } else {
                      game.download()
                    }
                default:
                    if self.activeSheet == nil {
                        self.activeSheet = sheet
                    } else {
                        self.activeSheetLayer2 = sheet
                    }
                }
            case .showActionSheet(let sheet): self.activeActionSheet = sheet
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
