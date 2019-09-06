import SwiftUI
import CoreData

struct GameListView: View {
    let fetchRequest: NSFetchRequest<GameEntity>
        
    init(fetchRequest: NSFetchRequest<GameEntity>) {
        self.fetchRequest = fetchRequest
    }
    
    var body: some View {
        TableView(fetchRequest, sectionNameKeyPath: "titleInitial") {
            GameListCell($0)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

