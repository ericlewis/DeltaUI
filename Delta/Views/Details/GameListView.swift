import SwiftUI
import CoreData

struct GameListView: View {
    @EnvironmentObject var currentlyPlaying: CurrentlyPlayingStore
    let fetchRequest: NSFetchRequest<GameEntity>
        
    init(fetchRequest: NSFetchRequest<GameEntity> = FetchRequests.recentlyPlayed(console: .all)) {
        self.fetchRequest = fetchRequest
    }
    
    var body: some View {
        TableView(fetchRequest, sectionNameKeyPath: "titleInitial", tapped: {
            self.currentlyPlaying.selected($0)()
        }) {
            GameListCell($0)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

