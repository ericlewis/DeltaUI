import SwiftUI
import SFSafeSymbols
import URLImage
import ProgressView

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
            if game == store.game {
                ActivityView()
            }
        }
        .contextMenu {
            GameContextMenu(game: game)
        }
    }
}
