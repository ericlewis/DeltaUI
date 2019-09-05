import SwiftUI

struct SearchViewContainer: View {
    @ObservedObject var store = SearchStore(console: .gba)
    
    var body: some View {
        SearchNavigationView(searchText: $store.searchTerm, scope: $store.scope, showScope: true) {
            SearchView(self.store)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RecentSearches: View {
    @ObservedObject var store: SearchStore
    @ObservedObject var recent: RecentStore

    var body: some View {
        Section(header: HStack {
            Text("Recent")
            .foregroundColor(.primary)
            .font(.title).bold()
            Spacer()
            Button(action: {
                self.recent.clear()
            }) {
                Text("Clear")
                .font(.body)
                .foregroundColor(.accentColor)
            }
        }
        .padding(.top)) {
            ForEach(recent.entries, id: \.self) { num in
                Button(action: {
                    self.store.searchTerm = String(num)
                }) {
                    Text(String(num))
                }
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject var recent: RecentStore
    @ObservedObject var store: SearchStore
    @ObservedObject var gba: SearchStore
    @ObservedObject var gbc: SearchStore
    @ObservedObject var gb: SearchStore
    @ObservedObject var snes: SearchStore
    @ObservedObject var nes: SearchStore
    
    init(_ store: SearchStore) {
        self.store = store
        self.recent = RecentStore()
        self.gba = SearchStore(console: .gba)
        self.gbc = SearchStore(console: .gbc)
        self.gb = SearchStore(console: .gb)
        self.snes = SearchStore(console: .snes)
        self.nes = SearchStore(console: .nes)
    }
    
    @State var last: CGFloat? = nil
    
    var body: some View {
        Form {
            if store.searchTerm.isEmpty && !recent.entries.isEmpty {
                RecentSearches(store: store, recent: recent)
            }
            if !store.searchTerm.isEmpty {
                if !gba.games.isEmpty {
                    Section(header: HeaderView(console: .gba, isSeeAllEnabled: true, fetchRequest: self.$gba.fetchRequest).padding(.top), footer: MovingView()) {
                        ForEach(Array(gba.games.prefix(3))) {
                        GameListCell($0)
                    }
                }
                }
                if !gbc.games.isEmpty {
                    Section(header: HeaderView(console: .gbc, isSeeAllEnabled: true, fetchRequest: self.$gbc.fetchRequest).padding(.top)) {
                        ForEach(Array(gbc.games.prefix(3))) {
                            GameListCell($0)
                        }
                    }
                }
                if !gb.games.isEmpty {
                    Section(header: HeaderView(console: .gb, isSeeAllEnabled: true, fetchRequest: self.$gb.fetchRequest).padding(.top)) {
                        ForEach(Array(gb.games.prefix(3))) {
                            GameListCell($0)
                        }
                    }
                }
                if !snes.games.isEmpty {
                    Section(header: HeaderView(console: .snes, isSeeAllEnabled: true, fetchRequest: self.$snes.fetchRequest).padding(.top)) {
                        ForEach(Array(snes.games.prefix(3))) {
                            GameListCell($0)
                        }
                    }
                }
                if !nes.games.isEmpty {
                    Section(header: HeaderView(console: .nes, isSeeAllEnabled: true,  fetchRequest: self.$nes.fetchRequest).padding(.top)) {
                        ForEach(Array(nes.games.prefix(3))) {
                            GameListCell($0)
                        }
                    }
                }
            }
        }
        .onPreferenceChange(ScrollingKeyTypes.PrefKey.self) { values in
            // this whole mess just dismisses the keyboard
            if let last = self.last, let value = values.first?.bounds.minY, last > value && !self.store.searchTerm.isEmpty && (!self.gb.games.isEmpty || !self.gba.games.isEmpty || !self.gbc.games.isEmpty || !self.snes.games.isEmpty || !self.nes.games.isEmpty) {
                let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
                
                keyWindow?.endEditing(true)
                
                // save to the array
                self.recent.save(self.store.searchTerm)
            }
            
            self.last = values.first?.bounds.minY
        }
        .onReceive(self.store.$searchTerm, perform: {
            // seems terrible to do this
            self.gba.searchTerm = $0
            self.gbc.searchTerm = $0
            self.gb.searchTerm = $0
            self.snes.searchTerm = $0
            self.nes.searchTerm = $0
        })
        .onReceive(self.store.$scope, perform: {
            self.gba.scope = $0
            self.gbc.scope = $0
            self.gb.scope = $0
            self.snes.scope = $0
            self.nes.scope = $0
        })
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
