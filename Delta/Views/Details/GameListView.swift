import SwiftUI
import CoreData

struct GameListView: View {
    let fetchRequest: NSFetchRequest<ItemEntity>
        
    init(fetchRequest: NSFetchRequest<ItemEntity> = FetchRequests.recentlyPlayedDetail(console: .all)) {
        self.fetchRequest = fetchRequest
    }
    
    var body: some View {
        TableView(fetchRequest, sectionNameKeyPath: "titleInitial", tapped: ActionCreator().presentEmulator) { game in
            GameListCell(game)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

