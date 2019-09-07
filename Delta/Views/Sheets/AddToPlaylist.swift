import SwiftUI

struct AddToPlaylistView: View {
  @Environment(\.managedObjectContext) var context
  
  var game: GameEntity
  
  func addGame(_ playlist: PlaylistEntity) {
    playlist.addToGames(self.game)
    try? self.context.save()
    ActionCreator().dismiss()
  }
  
  var DoneButton: some View {
    Button(action: {
      ActionCreator().dismiss()
    }) {
      Text("Done").done()
    }
  }
  
  var body: some View {
    NavigationView {
      PlaylistsView(action: addGame)
      .navigationBarTitle("Add to Playlist")
      .navigationBarItems(trailing: DoneButton)
    }
    .accentColor(.purple)
  }
}
