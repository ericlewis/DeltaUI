import SwiftUI

struct PlaylistView: View {
    @ObservedObject var playlist: PlaylistEntity
    @ObservedObject var store = CollectionStore()
    
    init(playlist: PlaylistEntity) {
        self.playlist = playlist
    }
    
    var body: some View {
        List {
            ForEach(store.games) { game in
                GameListCell(game)
                    .onTapGesture(perform: ActionCreator().presentEmulator(game))
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
