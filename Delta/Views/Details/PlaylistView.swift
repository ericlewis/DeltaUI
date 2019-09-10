import SwiftUI

struct PlaylistView: View {
    @ObservedObject var playlist: CollectionEntity
    @ObservedObject var store = CollectionStore.shared
    
    init(playlist: CollectionEntity) {
        self.playlist = playlist
    }
    
    var body: some View {
        List {
            ForEach(store.games) { game in
                GameListCell(game)
            }
            .onDelete {
                ActionCreator().deleteGame(self.playlist, self.store.games[$0.first!])
            }
        }
        .onAppear {
            ActionCreator().loadGames(self.playlist)
        }
        .navigationBarTitle(playlist.title ?? "No Title")
    }
}
