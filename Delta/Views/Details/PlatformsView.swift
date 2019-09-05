import SwiftUI

struct PlatformsView: View {
    var body: some View {
        List {
            ConsoleCell(.gba)
            ConsoleCell(.gbc)
            ConsoleCell(.gb)
            ConsoleCell(.snes)
            ConsoleCell(.nes)
        }
        .navigationBarTitle("Platforms")
    }
}

struct PlatformsView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsView()
    }
}
