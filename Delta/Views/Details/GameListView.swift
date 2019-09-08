import SwiftUI
import CoreData

struct GameListView: View {
    let fetchRequest: NSFetchRequest<GameEntity>
        
    init(fetchRequest: NSFetchRequest<GameEntity> = FetchRequests.recentlyPlayedDetail(console: .all)) {
        self.fetchRequest = fetchRequest
    }
    
    var body: some View {
        TableView(fetchRequest, sectionNameKeyPath: "titleInitial", tapped: {
            ActionCreator().presentEmulator($0)
        }) { game in
            GameListCell(game)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

