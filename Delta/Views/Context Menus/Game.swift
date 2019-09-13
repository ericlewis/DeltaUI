import SwiftUI

struct GameContextMenu: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var game: ItemEntity
    
    func toggleFave() {
        ActionCreator().toggleFavorite(game)
    }
    
    var body: some View {
        Group {
            if SettingsStore.shared.gameContextMenu.showPlay {
                if game.isDownloaded {
                    Button(action: ActionCreator().presentEmulator(self.game)) {
                        HStack {
                            Text("Play")
                            Spacer()
                            Image(systemSymbol: .gamecontroller)
                        }
                    }
                }
            }
            if SettingsStore.shared.gameContextMenu.showFavorite {
                if !game.favorited {
                    Button(action: toggleFave) {
                        HStack {
                            Text("Favorite")
                            Spacer()
                            Image(systemSymbol: .heart)
                        }
                    }
                } else {
                    Button(action: toggleFave) {
                        HStack {
                            Text("Unfavorite")
                            Spacer()
                            Image(systemSymbol: .heartSlash)
                        }
                    }
                }
            }
            if SettingsStore.shared.gameContextMenu.showAddToPlaylist {
                Button(action: ActionCreator().presentAddToPlaylist(self.game)) {
                    HStack {
                        Text("Add to Playlist")
                        Spacer()
                        Image(systemSymbol: .textBadgePlus)
                    }
                }
            }
            if game.isDownloaded && SettingsStore.shared.gameContextMenu.showSaveStates {
                Button(action: ActionCreator().presentSavedStates(self.game)) {
                    HStack {
                        Text("View Save States")
                        Spacer()
                        Image(systemSymbol: .moon)
                    }
                }
            }
            if SettingsStore.shared.gameContextMenu.showSearchWeb {
                Button(action: ActionCreator().presentLookup(self.game)) {
                    HStack {
                        Text("Search Web")
                        Spacer()
                        Image(systemSymbol: .globe)
                    }
                }
            }
            if game.isDownloaded && SettingsStore.shared.gameContextMenu.showDeleteFromLibrary {
                Button(action: ActionCreator().presentRemoveFromLibraryConfirmation(self.game)) {
                    HStack {
                        Text("Delete from Library")
                        Spacer()
                        Image(systemSymbol: .trash)
                    }
                }
            }
        }
    }
}
