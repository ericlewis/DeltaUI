import SwiftUI

struct BrowseView: View {
    var body: some View {
        List {
            ConsoleLibraryCell(.gba, libraryOnly: false)
            ConsoleLibraryCell(.gbc, libraryOnly: false)
            ConsoleLibraryCell(.gb, libraryOnly: false)
            ConsoleLibraryCell(.snes, libraryOnly: false)
            ConsoleLibraryCell(.nes, libraryOnly: false)
        }
        .navigationBarTitle("Browse")
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
