import SwiftUI

struct PlaylistView: View {
  @ObservedObject var playlist: PlaylistEntity
  @ObservedObject var store: PlaylistStore
  
  init(playlist: PlaylistEntity) {
    self.playlist = playlist
    self.store = PlaylistStore(playlist)
  }
  
  var body: some View {
    List {
      ForEach(store.games) { game in
        GameListCell(game)
        .onTapGesture(perform: {
            ActionCreator().presentEmulator(game)
        })
      }
      .onDelete(perform: store.delete)
    }
    .navigationBarTitle(playlist.title ?? "No Title")
  }
}
