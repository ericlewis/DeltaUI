import SwiftUI

struct LibraryView: View {    
    @FetchRequest(fetchRequest: FetchRequests.recentlyAdded()) var results: FetchedGames
    @FetchRequest(fetchRequest: FetchRequests.recentlyAddedExtended()) var resultsExtended: FetchedGames
    
    @State var useExtended = false

    var body: some View {
        GridView(useExtended ? self.resultsExtended : self.results, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
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
        }.onAppear {
            self.useExtended = true
        }
        .onDisappear {
            self.useExtended = false
        }
        .padding(.horizontal)
        .navigationBarTitle("Library")
    }
}

struct LibraryButtons: View {
    var body: some View {
        Group {
            NavigationLink(destination: Destination.allFavorites()) {
                LibraryCell(title: "Favorites", showChevron: true)
            }
            NavigationLink(destination: Destination.allLibraryGames()) {
                LibraryCell(title: "Games", showChevron: true)
            }
            NavigationLink(destination: Destination.allPlatforms()) {
                LibraryCell(title: "Platforms", showChevron: true)
            }
            NavigationLink(destination: Destination.allPlaylists()) {
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
