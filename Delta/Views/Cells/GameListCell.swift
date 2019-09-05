import SwiftUI
import SFSafeSymbols
import URLImage

struct GameListCell: View {
  @EnvironmentObject var store: CurrentlyPlayingStore
  @ObservedObject var game: GameEntity
  
  init(_ game: GameEntity) {
    self.game = game
  }
  
  var body: some View {
    HStack {
      URLImage(game.image!, placeholder: {
        PlaceholderView()
          .frame(width: 80, height: 80)
      })
        .gameListImage()
      VStack(alignment: .leading) {
        Text(game.splitTitle.0 ?? "No Title")
          .gameGridTitle()
        if game.splitTitle.1 != nil {
          Text(game.splitTitle.1 ?? "")
            .gameGridSubtitle()
        }
      }
      Spacer()
      ZStack {
        Image(systemSymbol: .icloudAndArrowDown)
      }
      .foregroundColor(.accentColor)
    }
    .onTapGesture(perform: store.selected(game))
    .contextMenu {
      GameContextMenu(game: game)
    }
  }
}
