import SwiftUI

struct AddToPlaylistView: View {
  var collections = CollectionStore.shared
  var game: ItemEntity
  
  func addGame(_ playlist: CollectionEntity) {
    ActionCreator().addGameToPlaylist(playlist, game)
  }
  
  var body: some View {
    NavigationView {
    PlaylistsView(action: addGame)
      .navigationBarTitle("Add to Playlist")
      .navigationBarItems(trailing: DoneButton())
    }
    .accentColor(.purple)
  }
}
