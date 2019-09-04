import SwiftUI

class PlaylistStore: ObservableObject {
    @Published var games: [GameEntity] = []
}

struct PlaylistView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var playlist: PlaylistEntity
    @ObservedObject var store: PlaylistStore
    
    init(playlist: PlaylistEntity) {
        self.playlist = playlist
        self.store = PlaylistStore()
        self.store.games = playlist.games?.allObjects as? [GameEntity] ?? []
    }
    
    var body: some View {
        List {
            ForEach(store.games) {
                GameListCell($0)
            }
            .onDelete {
                let idx = $0.first!
                let game = self.store.games[idx]
                self.store.games.remove(at: idx)
                self.playlist.removeFromGames(game)
                try? self.context.save()
            }
        }
        .navigationBarTitle(playlist.title ?? "New Playlist")
    }
}
