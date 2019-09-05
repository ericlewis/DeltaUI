import SwiftUI

struct AddToPlaylist: View {
  @Binding var isShowing: Bool
  @Environment(\.managedObjectContext) var context
  
  var game: GameEntity
  
  func addGame(_ playlist: PlaylistEntity) {
    playlist.addToGames(self.game)
    try? self.context.save()
    self.isShowing.toggle()
  }
  
  var DoneButton: some View {
    Button(action: {
      self.isShowing.toggle()
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
