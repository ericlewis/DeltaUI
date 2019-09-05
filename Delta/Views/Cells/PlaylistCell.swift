import SwiftUI
import URLImage

struct PlaylistCell: View {
    @ObservedObject var playlist: PlaylistEntity
    
    init(_ playlist: PlaylistEntity) {
        self.playlist = playlist
    }
    
    var allGames: [GameEntity] {
        playlist.games?.allObjects as! [GameEntity]
    }
    
    var Images: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    URLImage(allGames[0].image!)
                    .square()
                    URLImage(allGames[1].image!)
                    .square()
                }
                HStack(spacing: 0) {
                    URLImage(allGames[2].image!)
                    .square()
                    URLImage(allGames[3].image!)
                    .square()
                }
            }
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var Placeholder: some View {
        ZStack {
            Rectangle()
            .fill(Color.accentColor)
            .aspectRatio(1, contentMode: .fit)
            Image(systemSymbol: .gamecontrollerFill)
            .imageScale(.large)
            .foregroundColor(.white)
        }
        .mask(RoundedRectangle(cornerRadius: 3))
        .frame(width: 80, height: 80)
    }
    
    var body: some View {
        HStack {
            if playlist.games?.count ?? 0 > 3 {
                Images
            } else if playlist.games?.count ?? 0 > 0 {
                URLImage(allGames[0].image!)
                .square()
                .mask(RoundedRectangle(cornerRadius: 3))
                .frame(width: 80, height: 80)
            } else {
                Placeholder
            }
            Text(playlist.title ?? "No Title")
        }
    }
}
