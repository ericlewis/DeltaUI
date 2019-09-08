import SwiftUI

struct Destination {
    static func allFavorites() -> some View {
        GameListView(fetchRequest: FetchRequests.allFavorites()).navigationBarTitle("Favorites")
    }
    
    static func allLibraryGames() -> some View {
        Self.games(.all).navigationBarTitle("Games")
    }
    
    static func gbaLibraryGames() -> some View {
        Self.games(.gba)
    }
    
    static func gbcLibraryGames() -> some View {
        Self.games(.gbc)
    }
    
    static func gbLibraryGames() -> some View {
        Self.games(.gb)
    }
    
    static func nesLibraryGames() -> some View {
        Self.games(.nes)
    }
    
    static func snesLibraryGames() -> some View {
        Self.games(.snes)
    }
    
    static func games(_ console: Console, inLibrary: Bool = true) -> some View {
        GameListView(fetchRequest: FetchRequests.allGames(console: console, inLibrary: inLibrary)).navigationBarTitle(console.title)
    }
}
