import SwiftUI
import URLImage

struct GameGridCell: View {
    @EnvironmentObject var store: CurrentlyPlayingStore
    @ObservedObject var game: GameEntity
    
    init(_ game: GameEntity) {
        self.game = game
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ZStack(alignment: .topTrailing) {
                URLImage(game.image!, placeholder: {
                    PlaceholderView()
                })
                    .gameGridImage()
                    .contextMenu {
                        GameContextMenu(game: game)
                }
                if game.task != nil || game == store.game {
                    ActivityView()
                    .padding(5)
                    .background(Color.white)
                    .mask(Circle())
                    .shadow(radius: 5)
                    .offset(x: -10, y: 10)
                }
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
