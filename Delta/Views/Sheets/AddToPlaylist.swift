import SwiftUI

struct AddToPlaylist: View {
    @Binding var isShowing: Bool
    @Environment(\.managedObjectContext) var context
    
    var game: GameEntity

    var body: some View {
        NavigationView {
            PlaylistsView { playlist in
                playlist.addToGames(self.game)
                try? self.context.save()
                self.isShowing.toggle()
            }
            .navigationBarTitle("Add to Playlist")
            .navigationBarItems(trailing: Button(action: {
                self.isShowing.toggle()
            }) {
                Text("Done").bold()
            })
        }
        .accentColor(.purple)
    }
}
