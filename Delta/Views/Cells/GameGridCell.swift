import SwiftUI
import URLImage

extension URLImage {
    func gameGridImage() -> some View {
        self.resizable()
            .renderingMode(.original)
            .aspectRatio(1, contentMode: .fit)
            .mask(RoundedRectangle(cornerRadius: 5))
    }
}

extension Text {
    func gameGridTitle() -> some View {
        self.foregroundColor(.primary)
            .lineLimit(1)
    }
    
    func gameGridSubtitle() -> some View {
        self.foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct GameGridCell: View {
    @EnvironmentObject var store: CurrentlyPlayingStore
    @Environment(\.managedObjectContext) var context
    
    @State var isShowingAddToPlaylist = false
    
    @ObservedObject var game: GameEntity
    
    init(_ game: GameEntity) {
        self.game = game
    }
    
    func pressed() {
        if game.hasROM {
            return store.selectedGame(game)
        }
    }
    
    func toggleFave() {
        game.favorited.toggle()
        try? game.managedObjectContext?.save()
    }
    
    var Placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.secondary)
                .aspectRatio(1, contentMode: .fit)
            ActivityView(color: .white)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            URLImage(game.image!, placeholder: {Placeholder})
                .gameGridImage()
                .contextMenu {
                    Button(action: {
                        self.pressed()
                    }) {
                        HStack {
                            Text("Play")
                            Spacer()
                            Image(systemSymbol: .gamecontroller)
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
            VStack(alignment: .leading, spacing: 0) {
                Text(game.splitTitle.0 ?? "No Title")
                    .gameGridTitle()
                Text(game.splitTitle.1 ?? " ")
                    .gameGridSubtitle()
            }
        }
        .onTapGesture(perform: pressed)
        
    }
}
