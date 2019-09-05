import SwiftUI

struct LibraryView: View {    
  @FetchRequest(fetchRequest: FetchRequests.recentlyAdded()) var results: FetchedGames

  var body: some View {
    GridView(results, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
      VStack(alignment: .leading) {
        Divider()
        LibraryButtons()
        Text("Recently Added")
          .font(.title)
          .bold()
          .padding(.top)
      }
    }) {
      GameGridCell($0)
    }
    .padding(.horizontal)
    .navigationBarTitle("Library")
  }
}

struct LibraryButtons: View {
  var body: some View {
    Group {
      NavigationLink(destination: GameListView(fetchRequest: FetchRequests.allFavorites()).navigationBarTitle("Favorites")) {
        LibraryCell(title: "Favorites", showChevron: true)
      }
      NavigationLink(destination: GameListView(fetchRequest: FetchRequests.allGames(console: .all, inLibrary: true)).navigationBarTitle("Games")) {
        LibraryCell(title: "Games", showChevron: true)
      }
      NavigationLink(destination: PlatformsView()) {
        LibraryCell(title: "Platforms", showChevron: true)
      }
      NavigationLink(destination: PlaylistsView()) {
        LibraryCell(title: "Playlists", showChevron: true)
      }
    }
  }
}

struct LibraryView_Previews: PreviewProvider {
  static var previews: some View {
    LibraryView()
  }
}
