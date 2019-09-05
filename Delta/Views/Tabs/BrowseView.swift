import SwiftUI

struct BrowseView: View {
    @State var isShowingWebBrowser = false
    
    var body: some View {
        List {
            ConsoleLibraryCell(.gba, libraryOnly: false)
            ConsoleLibraryCell(.gbc, libraryOnly: false)
            ConsoleLibraryCell(.gb, libraryOnly: false)
            ConsoleLibraryCell(.snes, libraryOnly: false)
            ConsoleLibraryCell(.nes, libraryOnly: false)
        }
        .navigationBarTitle("Browse")
        .navigationBarItems(trailing: Button(action: {
            self.isShowingWebBrowser.toggle()
        }) {
            Image(systemSymbol: .globe)
            .sheet(isPresented: $isShowingWebBrowser) {
                WebViewChrome()
            }
        })
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
