import SwiftUI

struct BrowseView: View {
    var body: some View {
        List {
            ConsoleCell(.gba, libraryOnly: false)
            ConsoleCell(.gbc, libraryOnly: false)
            ConsoleCell(.gb, libraryOnly: false)
            ConsoleCell(.snes, libraryOnly: false)
            ConsoleCell(.nes, libraryOnly: false)
        }
        .navigationBarTitle("Browse")
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
