import SwiftUI

struct Destination {
    static func allFavorites() -> some View {
        GameListView(fetchRequest: FetchRequests.allFavorites()).navigationBarTitle("Favorites")
    }
    
    static func allLibraryGames() -> some View {
        GameListView(fetchRequest: FetchRequests.allGames(console: .all, inLibrary: true)).navigationBarTitle("Games")
    }
}
