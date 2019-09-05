import SwiftUI

struct GameContextMenu: View {
  @Environment(\.managedObjectContext) var context
  @EnvironmentObject var currentlyPlaying: CurrentlyPlayingStore

  @ObservedObject var game: GameEntity
  
  @State private var isShowingAddToPlaylist = false
  
  func play() {
    currentlyPlaying.selectedGame(game)
  }
  
  func toggleFave() {
    game.favorited.toggle()
    try? game.managedObjectContext?.save()
  }
  
  func download() {
    
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
        Button(action: download) {
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
                  Image(systemSymbol: .star)
              }
          }
      } else {
          Button(action: toggleFave) {
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
      if game.hasROM {
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
