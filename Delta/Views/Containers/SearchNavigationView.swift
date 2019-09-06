import SwiftUI

struct SearchNavigationView<Content: View>: UIViewControllerRepresentable {
    @Binding var searchText: String
    @Binding var scope: Int
    var showScope: Bool = false
    var content: () -> Content
    
    init(searchText: Binding<String>, scope: Binding<Int>, showScope: Bool, @ViewBuilder content: @escaping () -> Content) {
        _searchText = searchText
        _scope = scope
        self.showScope = showScope
        self.content = content
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: UIHostingController(rootView: content()))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        guard uiViewController.topViewController?.navigationItem.searchController == nil else {
            let text = uiViewController.topViewController?.navigationItem.searchController?.searchBar.text
            
            if text != searchText {
                uiViewController.topViewController?.navigationItem.searchController?.searchBar.text = searchText
            }
            
            let scope = uiViewController.topViewController?.navigationItem.searchController?.searchBar.selectedScopeButtonIndex

            if scope != self.scope {
                uiViewController.topViewController?.navigationItem.searchController?.searchBar.selectedScopeButtonIndex = self.scope
            }
            
            return
        }
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = context.coordinator
        search.obscuresBackgroundDuringPresentation = false
        if showScope {
            search.automaticallyShowsScopeBar = true
            search.searchBar.showsScopeBar = true
            search.searchBar.delegate = context.coordinator
            search.searchBar.scopeButtonTitles = ["Your Library", "All"]
        }
        uiViewController.topViewController?.navigationItem.searchController = search
        uiViewController.topViewController?.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
        var parent: SearchNavigationView
        
        init(_ parent: SearchNavigationView) {
            self.parent = parent
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            parent.searchText = searchController.searchBar.text ?? ""
        }
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            parent.scope = selectedScope
        }
    }
}
