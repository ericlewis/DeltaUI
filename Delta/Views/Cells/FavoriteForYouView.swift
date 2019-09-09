import SwiftUI

struct FavoriteForYouView: View {
    var body: some View {
        NavigationLink(destination: Destination.allFavorites()) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.purple).aspectRatio(1.8, contentMode: .fit)
                Text("Favorites").font(.title).bold().foregroundColor(.white)
            }
            .padding([.horizontal, .bottom])
            .shadow(radius: 5)
        }
    }
}
