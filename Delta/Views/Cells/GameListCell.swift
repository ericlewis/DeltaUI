import SwiftUI
import SFSafeSymbols
import URLImage
import ProgressView

struct GameListCell: View {
    @ObservedObject var game: ItemEntity

    init(_ game: ItemEntity) {
        self.game = game
    }

    var body: some View {
        HStack {
            if game.imageURL != nil {
                URLImage(game.imageURL!, placeholder: {
                    PlaceholderView(cornerRadius: 3)
                        .frame(width: 80, height: 80)
                }, configuration: ImageLoaderConfiguration(useInMemoryCache: true))
                    .gameListImage()
            } else {
                ZStack {
                    PlaceholderView(cornerRadius: 3, showIndicator: false)
                    Image(systemSymbol: .eyeSlash).foregroundColor(.white)
                }
                .frame(width: 80, height: 80)
            }
            VStack(alignment: .leading) {
                Text(game.title ?? "No Title")
                    .gameGridTitle()
                    .font(.body)
                if game.task != nil {
                    ProgressView(.constant(game.task?.progressValue ?? 0))
                    .animation(.spring())
                }
            }
            Spacer()
            if !game.isDownloaded && game.task == nil {
                Image(systemSymbol: .icloudAndArrowDown)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.accentColor)
                .animation(.spring())
            }
        }
        .onTapGesture(perform: ActionCreator().presentEmulator(game))
        .contextMenu {
            GameContextMenu(game: game)
        }
    }
}
