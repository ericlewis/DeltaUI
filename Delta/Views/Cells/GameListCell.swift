import SwiftUI
import SFSafeSymbols
import URLImage
import ProgressView

struct GameListCell: View {
    @ObservedObject var game: GameEntity
    
    init(_ game: GameEntity) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            URLImage(game.image!, placeholder: {
                PlaceholderView(cornerRadius: 3)
                    .frame(width: 80, height: 80)
            }, configuration: ImageLoaderConfiguration(useInMemoryCache: true))
                .gameListImage()
            VStack(alignment: .leading) {
                Text(game.splitTitle.0 ?? "No Title")
                    .gameGridTitle()
                    .font(.body)
                if game.splitTitle.1 != nil {
                    Text(game.splitTitle.1 ?? "")
                        .gameGridSubtitle()
                }
                if game.task != nil {
                    ProgressView(.constant(game.task?.progressValue ?? 0))
                    .animation(.spring())
                }
            }
            Spacer()
            if !game.hasROM && game.task == nil {
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
