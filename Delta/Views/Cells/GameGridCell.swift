import SwiftUI
import URLImage

struct GameGridCell: View {
  @EnvironmentObject var store: CurrentlyPlayingStore
  @Environment(\.managedObjectContext) var context
  
  @ObservedObject var game: GameEntity
  
  init(_ game: GameEntity) {
    self.game = game
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      URLImage(game.image!, placeholder: {
        PlaceholderView()
        
      })
        .gameGridImage()
        .contextMenu {
          GameContextMenu(game: game)
      }
      VStack(alignment: .leading, spacing: 0) {
        Text(game.splitTitle.0 ?? "No Title")
          .gameGridTitle()
        Text(game.splitTitle.1 ?? " ")
          .gameGridSubtitle()
      }
    }
    .onTapGesture(perform: store.selected(game))
    
  }
}
