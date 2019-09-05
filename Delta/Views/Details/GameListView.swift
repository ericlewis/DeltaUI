import SwiftUI
import CoreData

struct GameListView: View {
    @FetchRequest(fetchRequest: FetchRequests.allGames(console: .gba, inLibrary: true)) var results: FetchedGames
        
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
