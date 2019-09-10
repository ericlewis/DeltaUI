import SwiftUI
import URLImage
import ActivityIndicatorView

struct GameGridCell: View {
    @ObservedObject var game: ItemEntity
    
    init(_ game: ItemEntity) {
        self.game = game
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ZStack(alignment: .topTrailing) {
                if game.imageURL == nil {
                    PlaceholderView()
                } else {
                    URLImage(game.imageURL!, placeholder: {
                        PlaceholderView()
                    }, configuration: ImageLoaderConfiguration(useInMemoryCache: true))
                        .gameGridImage()
                        .contextMenu {
                            GameContextMenu(game: game)
                    }
                }
                if game.task != nil {
                    ActivityIndicatorView()
                    .padding(5)
                    .background(Color.white)
                    .mask(Circle())
                    .shadow(radius: 5)
                    .offset(x: -10, y: 10)
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(game.title ?? "No Title")
            }
        }
        .onTapGesture(perform: ActionCreator().presentEmulator(self.game))
    }
}
