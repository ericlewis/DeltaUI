import SwiftUI

struct ForYouView: View {
    var body: some View {
        ScrollView {
            Divider()
                .padding([.leading, .bottom])
            FavoriteForYouView()
            Divider()
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
