import SwiftUI
import CoreData

extension String {
    var searchify: String {
        self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct GameListView: View {
    @FetchRequest(fetchRequest: FetchRequests.allGames(console: .gba, inLibrary: true)) var results: FetchedGames
    
    // TODO: make lazier initializers (templates), where we can pass data and manage all here, or extensions.
    
    init(fetchRequest: NSFetchRequest<GameEntity>) {
        _results = .init(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach(results) { rom in
                GameListCell(rom)
            }
        }
        .listStyle(DefaultListStyle())
    }
}
