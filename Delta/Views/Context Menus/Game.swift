import SwiftUI

struct GameContextMenu: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var currentlyPlaying: CurrentlyPlayingStore
    
    @ObservedObject var game: GameEntity
    
    @State private var isShowingAddToPlaylist = false
    @State private var isShowingConfirmRemove = false
    @State private var isShowingSaveStates = false

    func play() {
        currentlyPlaying.selectedGame(game)
    }
    
    func toggleFave() {
        game.objectWillChange.send()
        game.favorited.toggle()
        try? game.managedObjectContext?.save()
    }
    
    func toggleConfirmRemove() {
        isShowingConfirmRemove.toggle()
    }
    
    var body: some View {
        Group {
            if game.hasROM {
                Button(action: play) {
                    HStack {
                        Text("Play")
                        Spacer()
                        Image(systemSymbol: .gamecontroller)
                    }
                }
            }
            if !game.hasROM {
                Button(action: game.download) {
                    HStack {
                        Text("Download")
                        Spacer()
                        Image(systemSymbol: .icloudAndArrowDown)
                    }
                }
            }
            if !game.favorited {
                Button(action: toggleFave) {
                    HStack {
                        Text("Favorite")
                        Spacer()
                        Image(systemSymbol: .heart)
                    }
                }
            } else {
                Button(action: toggleFave) {
                    HStack {
                        Text("Unfavorite")
                        Spacer()
                        Image(systemSymbol: .heartSlash)
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
            Button(action: {
                self.isShowingSaveStates.toggle()
            }) {
                HStack {
                    Text("View Save States")
                    Spacer()
                    Image(systemSymbol: .moon)
                }
            }
            .sheet(isPresented: $isShowingSaveStates) {
                SaveStatesView(game: self.game) {
                    self.isShowingSaveStates = false
                    self.currentlyPlaying.selectedSave($0)
                }
            }
            if game.hasROM {
                Button(action: toggleConfirmRemove) {
                    HStack {
                        Text("Delete from Library")
                        Spacer()
                        Image(systemSymbol: .trash)
                    }
                }
                .actionSheet(isPresented: $isShowingConfirmRemove) {
                    ActionSheet(title: Text("Are you sure you want to remove this game from your library?"), message: nil, buttons: [
                        .destructive(Text("Delete Game")) {
                            self.game.deleteFromLibrary()
                        },
                        .cancel()
                        ])
                }
            }
        }
    }
}
