import SwiftUI

struct PlaylistsView: View {
  typealias Action = ((PlaylistEntity) -> Void)?
  
  @Environment(\.managedObjectContext) var context
  @FetchRequest(fetchRequest: FetchRequests.allPlaylists()) var results: FetchedResults<PlaylistEntity>
  
  @State var isShowingNewPlaylist = false
  @State var playlistTitleInput = ""
  
  var action: Action
  
  init(action: Action = nil) {
    self.action = action
  }
  
  func save() {
    PlaylistEntity.create(title: playlistTitleInput, context: context) {
      self.isShowingNewPlaylist.toggle()
      self.playlistTitleInput = ""
    }
  }
  
  func toggleAddPlaylist() {
    self.isShowingNewPlaylist.toggle()
  }
  
  func delete(_ index: IndexSet) {
    self.context.delete(self.results[index.first!])
    try? self.context.save()
  }
  
  var body: some View {
    List {
      if !isShowingNewPlaylist {
        Button(action: toggleAddPlaylist) {
          AddCell()
        }
      }
      if isShowingNewPlaylist {
        HStack {
          TextField("New Playlist Title", text: $playlistTitleInput, onCommit: save)
          Button(action: save) {
            Text(playlistTitleInput.isEmpty ? "Cancel" : "Create")
              .done()
          }
        }
        .padding(.vertical)
      }
      ForEach(results, id: \.id) { playlist in
        (self.action == nil ? AnyView(NavigationLink(destination: PlaylistView(playlist: playlist)) {
          PlaylistCell(playlist)
        }) : AnyView(Button(action: {
          self.action?(playlist)
        }) {
          PlaylistCell(playlist)
        }))
          .deleteDisabled(self.action != nil)
      }
      .onDelete(perform: delete)
      .disabled(isShowingNewPlaylist)
    }
    .navigationBarTitle("Playlists")
  }
}
