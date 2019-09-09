import SwiftUI
import URLImage

struct GameGridCell: View {
    @ObservedObject var game: GameEntity
    
    init(_ game: GameEntity) {
        self.game = game
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ZStack(alignment: .topTrailing) {
                URLImage(game.image!, placeholder: {
                    PlaceholderView()
                }, configuration: ImageLoaderConfiguration(useInMemoryCache: true))
                    .gameGridImage()
                    .contextMenu {
                        GameContextMenu(game: game)
                }
                if game.task != nil {
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
        .onTapGesture(perform: ActionCreator().presentEmulator(self.game))
    }
}
