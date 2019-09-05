import SwiftUI

struct RootView: View {    
    @State var selection = 0

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
        TabView(selection: $selection) {
            libraryTab
            forYouTab
            browseTab
            searchTab
            settingsTab
        }
        .overlay(DeltaView())
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
