import SwiftUI

struct PlatformsView: View {
    var body: some View {
        List {
            ConsoleLibraryCell(.gba)
            ConsoleLibraryCell(.gbc)
            ConsoleLibraryCell(.gb)
            ConsoleLibraryCell(.snes)
            ConsoleLibraryCell(.nes)
        }
        .navigationBarTitle("Platforms")
    }
}

struct PlatformsView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsView()
    }
}
