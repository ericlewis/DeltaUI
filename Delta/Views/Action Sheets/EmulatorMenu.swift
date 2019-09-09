import SwiftUI

extension ActionSheet {
    static func EmulatorMenu() -> ActionSheet {
        ActionSheet(title: Text("Menu"), message: nil, buttons: [
            NavigationStore.shared.currentGame!.favorited ?
                .default(Text("Unfavorite")) {
                    ActionCreator().toggleFavorite(NavigationStore.shared.currentGame!)
                }
                : .default(Text("Favorite")) {
                    ActionCreator().toggleFavorite(NavigationStore.shared.currentGame!)
            },
            .default(Text("Add to Playlist")) {
                guard let game = NavigationStore.shared.currentGame else {
                    return
                }
                
                ActionCreator().presentAddToPlaylist(game)()
            },
            .default(Text("View Saved States")) {
                guard let game = NavigationStore.shared.currentGame else {
                    return
                }
                
                ActionCreator().presentSavedStates(game)()
            },
            .default(Text("Save State"), action: ActionCreator().saveState),
            .destructive(Text("Close & Auto Save Game"), action: ActionCreator().dismiss),
            .cancel()
        ])
    }
}
