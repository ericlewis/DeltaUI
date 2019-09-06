import SwiftUI

extension ActionSheet {
    static func EmulatorMenu(store: CurrentlyPlayingStore, menu: MenuStore, saveState: @escaping () -> Void) -> ActionSheet {
        ActionSheet(title: Text("Menu"), message: Text(store.game?.title ?? ""), buttons: [
            store.game!.favorited ? .default(Text("Unfavorite")) {
                store.game?.favorited.toggle()
                } : .default(Text("Favorite")) {
                    store.game?.favorited.toggle()
            },
            .default(Text("Add to Playlist")) {
                menu.isShowingSavedStates = false
                menu.isShowingAddToPlaylist.toggle()
            },
            .default(Text("View Saved States")) {
                menu.isShowingAddToPlaylist.toggle() // lazy af, we just reuse the same toggle and set another. this needs to be a proper enum
                menu.isShowingSavedStates = true
            },
            .default(Text("Save State")) {
                saveState()
            },
            .destructive(Text("Close & Auto Save Game")) {
                store.isShowingEmulator.toggle()
            },
            .cancel()
        ])
    }
}
