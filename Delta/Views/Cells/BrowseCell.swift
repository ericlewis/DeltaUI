import SwiftUI

struct BrowseCell: View {
    var console: Console
    
    init(_ console: Console) {
        self.console = console
    }
    
    var body: some View {
        NavigationLink(destination: Destination.games(console, inLibrary: false)) {
            ZStack() {
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.purple).aspectRatio(1.8, contentMode: .fit)
                Text(console.title).font(.title).bold().foregroundColor(.white)
            }
            .padding([.leading, .trailing])
            .shadow(radius: 5)
        }
    }
}
