import SwiftUI
import SFSafeSymbols
import URLImage

extension URLImage {
    func gameListImage() -> some View {
        self.resizable()
        .renderingMode(.original)
        .aspectRatio(1, contentMode: .fit)
        .foregroundColor(.accentColor)
        .frame(width: 80, height: 80)
        .mask(RoundedRectangle(cornerRadius: 3))
    }
}

struct GameListCell: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var store: CurrentlyPlayingStore
    
    @ObservedObject var game: GameEntity
    
    @State private var downloading = false
    @State var isShowingAddToPlaylist = false

    init(_ game: GameEntity) {
        self.game = game
    }
    
    func pressed() {
        if downloading {
            return
        }
        
        if game.hasROM {
            return store.selectedGame(game)
        }
        
        downloading = true
        game.download { _ in
            self.downloading = false
        }
    }
    
    func toggleFave() {
        game.favorited.toggle()
        try? game.managedObjectContext?.save()
    }
    
    var Placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(.gray)
                .aspectRatio(1, contentMode: .fit)
            ActivityView(color: .white)
        }
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            URLImage(game.image!, placeholder: {Placeholder})
            .gameListImage()
            VStack(alignment: .leading) {
                Text(game.splitTitle.0 ?? "No Title")
                .lineLimit(1)
                .foregroundColor(.primary)
                if game.splitTitle.1 != nil {
                    Text(game.splitTitle.1 ?? "")
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                }
            }
            Spacer()
            ZStack {
                if downloading {
                    ActivityView()
                } else if !downloading && !game.hasROM {
                    Image(systemSymbol: .icloudAndArrowDown)
                }
            }
            .foregroundColor(.accentColor)
        }
        .onTapGesture(perform: pressed)
        .contextMenu {
            if self.game.hasROM {
                Button(action: self.pressed) {
                    HStack {
                        Text("Play")
                        Spacer()
                        Image(systemSymbol: .gamecontroller)
                    }
                }
            } else {
                Button(action: self.pressed) {
                    HStack {
                        Text("Download")
                        Spacer()
                        Image(systemSymbol: .icloudAndArrowDown)
                    }
                }
            }
            if !self.game.favorited {
                Button(action: self.toggleFave) {
                    HStack {
                        Text("Favorite")
                        Spacer()
                        Image(systemSymbol: .star)
                    }
                }
            } else {
                Button(action: self.toggleFave) {
                    HStack {
                        Text("Unfavorite")
                        Spacer()
                        Image(systemSymbol: .starFill)
                    }
                }
            }
            Button(action: {
                self.isShowingAddToPlaylist.toggle()
            }) {
                HStack {
                    Text("Add to Playlist")
                    Spacer()
                    Image(systemSymbol: .textBadgePlus)
                }
            }
            .sheet(isPresented: $isShowingAddToPlaylist) {
                AddToPlaylist(isShowing: self.$isShowingAddToPlaylist, game: self.game)
                .environment(\.managedObjectContext, self.context)
            }
            if self.game.hasROM {
                Button(action: {
                }) {
                    HStack {
                        Text("Delete from Library")
                        Spacer()
                        Image(systemSymbol: .trash)
                    }
                }
            }
        }
    }
}
