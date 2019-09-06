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

struct HorizontalGameScroller: View {
    @FetchRequest(fetchRequest: FetchRequests.recentlyPlayed(console: .gba)) var results: FetchedGames
    
    var console: Console
    var text: String?
    var action: (() -> Void)?
    
    init(_ console: Console, text: String? = nil, action: (() -> Void)? = nil) {
        self.console = console
        self.text = text
        self.action = action
        _results = .init(fetchRequest: FetchRequests.recentlyPlayed(console: console))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(console: console, isSeeAllEnabled: console == .all, fetchRequest: .constant(nil))
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Text("").padding(.leading)
                    ForEach(results) {
                        GameGridCell($0)
                        .frame(width: 200)
                        .padding(.trailing)
                    }
                }
            }
            .padding(.bottom)
            Divider()
            .padding(.horizontal)
        }
    }
}

struct FavoriteForYouView: View {
    var body: some View {
        NavigationLink(destination: Destination.allFavorites()) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.purple).aspectRatio(1.8, contentMode: .fit)
                Text("Favorites").font(.title).bold().foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct ForYouView: View {
    var body: some View {
        ScrollView {
            FavoriteForYouView()
            Divider()
                .padding(.leading)
            HorizontalGameScroller(.all, text: "Recently Played")
            HorizontalGameScroller(.gba)
            HorizontalGameScroller(.gbc)
            HorizontalGameScroller(.gb)
            HorizontalGameScroller(.snes)
            HorizontalGameScroller(.nes)
        }
        .navigationBarTitle("For You")
    }
}

struct ForYouView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouView()
    }
}
