import SwiftUI

struct SearchViewContainer: View {
    @ObservedObject var store = SearchStore()
    
    var body: some View {
        SearchNavigationView(searchText: $store.searchTerm, scope: $store.scope, showScope: true) {
            SearchView(self.store)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RecentSearches: View {
    @ObservedObject var recent = RecentsStore.shared
    var tappedRecent: (String) -> Void
    
    var body: some View {
        Section(header: HStack {
            Text("Recent")
                .foregroundColor(.primary)
                .font(.title).bold()
            Spacer()
            Button(action: ActionCreator().clearRecentSearches) {
                Text("Clear")
                    .font(.body)
                    .foregroundColor(.accentColor)
            }
        }) {
            ForEach(recent.entries, id: \.self) { text in
                Button(action: {
                    self.tappedRecent(text)
                }) {
                    Text(text)
                }
            }
        }
        .onAppear {
            ActionCreator().loadRecentSearches()
        }
    }
}

struct SearchView: View {
    @ObservedObject var store: SearchStore
    
    init(_ store: SearchStore) {
        self.store = store
    }
    
    @State var last: CGFloat? = nil
    
    var body: some View {
        Form {
            if store.searchTerm.isEmpty {
                RecentSearches {
                    self.store.searchTerm = $0
                }
            } else {
                Section(header: Text("Gameboy Advance").foregroundColor(.primary).font(.title).bold().background(MovingView())) {
                    if store.gba.isEmpty {
                        Text("No Results").foregroundColor(.secondary)
                    }
                    ForEach(store.gba) { game in
                        GameListCell(game)
                    }
                }
                Section(header: Text("Gameboy Color").foregroundColor(.primary).font(.title).bold()) {
                    if store.gbc.isEmpty {
                        Text("No Results").foregroundColor(.secondary)
                    }
                    ForEach(store.gbc) { game in
                        GameListCell(game)
                    }
                }
                Section(header: Text("Gameboy").foregroundColor(.primary).font(.title).bold()) {
                    if store.gb.isEmpty {
                        Text("No Results").foregroundColor(.secondary)
                    }
                    ForEach(store.gb) { game in
                        GameListCell(game)
                    }
                }
                Section(header: Text("Super Nintendo").foregroundColor(.primary).font(.title).bold()) {
                    if store.snes.isEmpty {
                        Text("No Results").foregroundColor(.secondary)
                    }
                    ForEach(store.snes) { game in
                        GameListCell(game)
                    }
                }
                Section(header: Text("Nintendo").foregroundColor(.primary).font(.title).bold()) {
                    if store.nes.isEmpty {
                        Text("No Results").foregroundColor(.secondary)
                    }
                    ForEach(store.nes) { game in
                        GameListCell(game)
                    }
                }
            }
        }
        .onPreferenceChange(ScrollingKeyTypes.PrefKey.self) { values in
            // this whole mess just dismisses the keyboard
            if let last = self.last, let value = values.first?.bounds.minY, last > value && !self.store.searchTerm.isEmpty && (!self.store.gb.isEmpty || !self.store.gba.isEmpty || !self.store.gbc.isEmpty || !self.store.snes.isEmpty || !self.store.nes.isEmpty) {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                
                keyWindow?.endEditing(true)
                
                ActionCreator().save(searchTerm: self.store.searchTerm)
            }
            
            self.last = values.first?.bounds.minY
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Search")
    }
}

struct MovingView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollingKeyTypes.PrefKey.self, value: [ScrollingKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
        }.frame(height: 0)
    }
}

struct ScrollingKeyTypes {
    enum ViewType: Int {
        case movingView
    }
    
    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }
    
    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []
        
        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }
        
        typealias Value = [PrefData]
    }
}
