import SwiftUI
import ActivityIndicatorView

struct ForYouView: View {
    
    @State var showScrollers = false
    
    var body: some View {
        ScrollView {
            Divider()
                .padding([.leading, .bottom])
            FavoriteForYouView()
            Divider()
            if showScrollers {
                HorizontalGameScroller(.all, text: "Recently Played")
                HorizontalGameScroller(.gba)
                HorizontalGameScroller(.gbc)
                HorizontalGameScroller(.gb)
                HorizontalGameScroller(.snes)
                HorizontalGameScroller(.nes)
            } else {
                ActivityIndicatorView(style: .large)
                .padding(.top)
            }
        }
        .onAppear {
            // self.showScrollers = true
        }
        .onDisappear {
            // self.showScrollers = false
        }
        .navigationBarTitle("For You")
    }
}

struct ForYouView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouView()
    }
}
