import SwiftUI

struct RootView: View {    
    @EnvironmentObject var navigation: NavigationStore

    var libraryTab: some View {
        NavigationView {
            LibraryView()
        }
        .tag(0)
        .tabItem {
            Image(systemSymbol: .squareStack3dDownRightFill)
            Text("Library")
        }
    }
    
    var forYouTab: some View {
        NavigationView {
                ForYouView()
        }
        .tag(1)
        .tabItem {
            Image(systemSymbol: .heartFill)
            Text("For You")
        }
    }
    
    var browseTab: some View {
        NavigationView {
                BrowseView()
        }
        .tag(2)
        .tabItem {
            Image(systemSymbol: .listDash)
            Text("Browse")
        }
    }
    
    var searchTab: some View {
            SearchViewContainer()
        .tag(3)
        .tabItem {
            Image(systemSymbol: .magnifyingglass)
            Text("Search")
        }
    }
    
    var settingsTab: some View {
        NavigationView {
                SettingsView()
        }
        .tag(4)
        .tabItem {
            Image(systemSymbol: .gear)
            Text("Settings")
        }
    }
    
    var body: some View {
        SheetPresenter {
            TabView(selection: self.$navigation.selectedTab) {
                self.libraryTab
                self.forYouTab
                self.browseTab
                self.searchTab
                self.settingsTab
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
