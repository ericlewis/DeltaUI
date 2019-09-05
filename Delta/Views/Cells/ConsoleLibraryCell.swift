import SwiftUI

struct ConsoleCell: View {
    var console: Console
    var libraryOnly: Bool
    
    init(_ console: Console, libraryOnly: Bool = true) {
        self.console = console
        self.libraryOnly = libraryOnly
    }
    
    var body: some View {
        NavigationLink(destination: GameListView(fetchRequest: FetchRequests.allGames(console: console, inLibrary: libraryOnly)).navigationBarTitle(console.title)) {
            LibraryCell(title: console.title, showChevron: false)
        }
    }
}
