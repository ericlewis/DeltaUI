import SwiftUI
import URLImage

struct PlaylistCell: View {
    @ObservedObject var playlist: CollectionEntity
    
    init(_ playlist: CollectionEntity) {
        self.playlist = playlist
    }
    
    var allGames: [ItemEntity] {
        playlist.games?.allObjects as! [ItemEntity]
    }
    
    var Images: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    URLImage(allGames[0].imageURL!)
                    .square()
                    URLImage(allGames[1].imageURL!)
                    .square()
                }
                HStack(spacing: 0) {
                    URLImage(allGames[2].imageURL!)
                    .square()
                    URLImage(allGames[3].imageURL!)
                    .square()
                }
            }
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            if playlist.games?.count ?? 0 > 3 {
                Images
            } else if playlist.games?.count ?? 0 > 0 {
                URLImage(allGames[0].imageURL!)
                .square()
                .mask(RoundedRectangle(cornerRadius: 3))
                .frame(width: 80, height: 80)
            } else {
                ColorfulSquare(symbol: .playCircle)
                .frame(width: 80, height: 80)
            }
            Text(playlist.title ?? "No Title")
        }
    }
}
