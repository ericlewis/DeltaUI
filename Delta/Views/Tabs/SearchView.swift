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
    @ObservedObject var store: SearchStore
    @ObservedObject var recent: RecentStore
    
    var body: some View {
        Section(header: HStack {
            Text("Recent")
                .foregroundColor(.primary)
                .font(.title).bold()
            Spacer()
            Button(action: self.recent.clear) {
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
    
    init(_ store: SearchStore) {
        self.store = store
        self.recent = RecentStore()
    }
    
    @State var last: CGFloat? = nil
    
    var body: some View {
        Form {
            if store.searchTerm.isEmpty {
                RecentSearches(store: store, recent: recent)
            } else {
                Section(header: Text("Gameboy Advance").foregroundColor(.primary).font(.title).bold().background(MovingView())) {
                    if store.gba.isEmpty {
                        Text("No Results")
                    }
                    ForEach(store.gba) {
                        GameListCell($0)
                    }
                }
                Section(header: Text("Gameboy Color").foregroundColor(.primary).font(.title).bold()) {
                    if store.gbc.isEmpty {
                        Text("No Results")
                    }
                    ForEach(store.gbc) {
                        GameListCell($0)
                    }
                }
                Section(header: Text("Gameboy").foregroundColor(.primary).font(.title).bold()) {
                    if store.gb.isEmpty {
                        Text("No Results")
                    }
                    ForEach(store.gb) {
                        GameListCell($0)
                    }
                }
                Section(header: Text("Nintendo").foregroundColor(.primary).font(.title).bold()) {
                    if store.nes.isEmpty {
                        Text("No Results")
                    }
                    ForEach(store.nes) {
                        GameListCell($0)
                    }
                }
                Section(header: Text("Super Nintendo").foregroundColor(.primary).font(.title).bold()) {
                    if store.snes.isEmpty {
                        Text("No Results")
                    }
                    ForEach(store.snes) {
                        GameListCell($0)
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
                
                // save to the array
                self.recent.save(self.store.searchTerm)
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
