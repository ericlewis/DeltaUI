import SwiftUI

struct BrowseView: View {
    var body: some View {
        ScrollView {
            Divider()
                .padding([.leading, .bottom])
            BrowseCell(.gba)
            BrowseCell(.gbc)
            BrowseCell(.gb)
            BrowseCell(.snes)
            BrowseCell(.nes)
        }
        .navigationBarTitle("Browse")
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
