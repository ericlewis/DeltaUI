import SwiftUI

enum SettingsKey: String {
    case swipeToDismiss, showSearchWeb, showAddToPlaylist, showPlay, showFavorite, showDeleteFromLibrary, showSaveStates, autoSaveOnClose, resumeFromAutoSave, notificationsEnabled
}

class GameContextMenuSettingsStore: ObservableObject {
    @PublishedSetting(key: .showSearchWeb) var showSearchWeb = true
    @PublishedSetting(key: .showAddToPlaylist) var showAddToPlaylist = true
    @PublishedSetting(key: .showPlay) var showPlay = true
    @PublishedSetting(key: .showFavorite) var showFavorite = true
    @PublishedSetting(key: .showDeleteFromLibrary) var showDeleteFromLibrary = true
    @PublishedSetting(key: .showSaveStates) var showSaveStates = true
}

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()
    
    @Published var gameContextMenu = GameContextMenuSettingsStore()
    @PublishedSetting(key: .notificationsEnabled) var notificationsEnabled = true
    @PublishedSetting(key: .swipeToDismiss) var swipeToDismiss = true
    @PublishedSetting(key: .autoSaveOnClose) var autoSaveOnClose = true
    @PublishedSetting(key: .resumeFromAutoSave) var resumeFromAutoSave = true
}

// NOTE: store is colocated for simplicity. these get updated together.

struct SettingsView: View {
    @ObservedObject var settings = SettingsStore.shared
    
    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle(isOn: $settings.notificationsEnabled) {
                    Text("Notifications")
                }
                NavigationLink(destination: List {
                    Section(header: Text("Downloaded Games")) {
                        Text("Game")
                    }
                    Section {
                        Text("Sync")
                    }
                    Section {
                        Text("Remove All ROMs").foregroundColor(.red)
                    }
                }.navigationBarTitle("Storage")) {
                    Text("Storage")
                }
            }
            Section(header: Text("Emulator")) {
                Toggle(isOn: $settings.swipeToDismiss) {
                    Text("Swipe to Dismiss")
                }
                Toggle(isOn: $settings.autoSaveOnClose) {
                    Text("Auto Save on Close")
                }
                Toggle(isOn: $settings.resumeFromAutoSave) {
                    Text("Resume from Auto Save")
                }
            }
            Section(header: Text("Context Menus")) {
                NavigationLink(destination: List {
                    Section(header: Text("Menu Items")) {
                        Toggle(isOn: $settings.gameContextMenu.showPlay) {
                            Text("Play")
                        }
                        Toggle(isOn: $settings.gameContextMenu.showFavorite) {
                            Text("Favorite")
                        }
                        Toggle(isOn: $settings.gameContextMenu.showAddToPlaylist) {
                            Text("Add to Playlist")
                        }
                        Toggle(isOn: $settings.gameContextMenu.showSaveStates) {
                            Text("View Save States")
                        }
                        Toggle(isOn: $settings.gameContextMenu.showSearchWeb) {
                            Text("Search Web")
                        }
                        Toggle(isOn: $settings.gameContextMenu.showDeleteFromLibrary) {
                            Text("Delete from Library")
                        }
                    }
                }.navigationBarTitle("Game Context Menu")) {
                    Text("Game")
                }
            }
            Section(header: Text("Information")) {
                Text("Version 1.0")
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
