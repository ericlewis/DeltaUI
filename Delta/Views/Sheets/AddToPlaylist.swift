import SwiftUI

struct AddToPlaylistView: View {
  @Environment(\.managedObjectContext) var context
  
  var game: GameEntity
  
  func addGame(_ playlist: PlaylistEntity) {
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
