import SwiftUI

class MenuStore: ObservableObject {
    @Published var isShowing = false
    @Published var shouldSave = false
    @Published var isShowingAddToPlaylist = false
}
