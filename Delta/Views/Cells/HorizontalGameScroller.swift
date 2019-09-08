import SwiftUI

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
