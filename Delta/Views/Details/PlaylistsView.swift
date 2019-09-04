import SwiftUI
import CoreData
import URLImage

struct PlaylistCell: View {
    @ObservedObject var playlist: PlaylistEntity
    
    init(_ playlist: PlaylistEntity) {
        self.playlist = playlist
    }
    
    var allGames: [GameEntity] {
        playlist.games?.allObjects as! [GameEntity]
    }
    
    var Images: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    URLImage(allGames[0].image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    URLImage(allGames[1].image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                }
                HStack(spacing: 0) {
                    URLImage(allGames[2].image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    URLImage(allGames[3].image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var Placeholder: some View {
        ZStack {
            Rectangle()
            .fill(Color.accentColor)
            .aspectRatio(1, contentMode: .fit)
            Image(systemSymbol: .gamecontrollerFill)
            .imageScale(.large)
            .foregroundColor(.white)
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            if playlist.games?.count ?? 0 > 3 {
                Images
            } else if playlist.games?.count ?? 0 > 0 {
                URLImage(allGames[0].image!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .mask(RoundedRectangle(cornerRadius: 3))
                .frame(width: 80, height: 80)
            } else {
                Placeholder
            }
            Text(playlist.title ?? "No Title")
        }
    }
}

struct AddCell: View {
    var Placeholder: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Circle()
                    .foregroundColor(.purple)
                    .aspectRatio(1, contentMode: .fit)
                    Circle()
                    .foregroundColor(.green)
                    .aspectRatio(1, contentMode: .fit)
                }
                HStack(spacing: 0) {
                    Circle()
                    .foregroundColor(.orange)
                    .aspectRatio(1, contentMode: .fit)
                    Circle()
                    .foregroundColor(.red)
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .blur(radius: 25)
            .saturation(1.5)
            Image(systemSymbol: .plus)
                .resizable()
                .imageScale(.large)
                .foregroundColor(.secondary)
                .padding()
                .blendMode(.hardLight)
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            Placeholder
            Text("New Playlist...")
            .foregroundColor(.accentColor)
        }
    }
}

struct PlaylistsView: View {
    typealias Action = ((PlaylistEntity) -> Void)?
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(fetchRequest: FetchRequests.allPlaylists()) var results: FetchedResults<PlaylistEntity>
    @State var isShowingNewPlaylist = false
    @State var playlistTitleInput = ""

    var action: Action
    
    init(action: Action = nil) {
        self.action = action
    }
    
    func savePlaylist() {
        if !self.playlistTitleInput.isEmpty {
            let playlist = PlaylistEntity(context: self.context)
            playlist.id = UUID()
            playlist.title = self.playlistTitleInput
            try? self.context.save()
        }

        self.isShowingNewPlaylist.toggle()
        self.playlistTitleInput = ""
    }
    
    var body: some View {
        List {
            if isShowingNewPlaylist == false {
                Button(action: {
                    self.isShowingNewPlaylist.toggle()
                }) {
                    AddCell()
                }
            }
            if isShowingNewPlaylist == true {
                HStack {
                    TextField("New Playlist Title", text: $playlistTitleInput) {
                        self.savePlaylist()
                    }
                    Button(action: self.savePlaylist) {
                        Text(playlistTitleInput.isEmpty ? "Cancel" : "Done").bold().foregroundColor(.purple)
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
                })).deleteDisabled(self.action != nil)
            }
            .onDelete { index in
                self.context.delete(self.results[index.first!])
                try? self.context.save()
            }
            .disabled(isShowingNewPlaylist)
        }
        .navigationBarTitle("Playlists")
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: Text

    var body: some View {
        ZStack {
            presenting
                .disabled(isShowing)
            VStack {
                title
                TextField("", text: $text)
                Divider()
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }) {
                        Text("Dismiss")
                    }
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 1)
            .opacity(isShowing ? 1 : 0)
        }
    }

}

extension View {

    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: Text) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       presenting: self,
                       title: title)
    }

}
