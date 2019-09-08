import SwiftUI
import CoreData

struct HeaderView: View {
    var console: Console
    var isSeeAllEnabled: Bool
    
    @Binding var fetchRequest: NSFetchRequest<GameEntity>?
    
    var body: some View {
        HStack {
            Text(console.title).font(.title).bold().foregroundColor(.primary)
            Spacer()
            if isSeeAllEnabled {
                NavigationLink(destination: GameListView(fetchRequest: fetchRequest ?? FetchRequests.recentlyPlayedDetail(console: console)).navigationBarTitle(console.title)) {
                    Text("See All")
                    .font(.body)
                }
            }
        }
    }
}
