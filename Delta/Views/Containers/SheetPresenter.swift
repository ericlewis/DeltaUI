import SwiftUI

struct SheetPresenter<Content>: View where Content: View {
    @EnvironmentObject var navigation: NavigationStore
    @Environment(\.managedObjectContext) var context
    
    var content: () -> Content
    
    // TODO: remove  bunch of these weird functions and put them in their components
    
    let dragBlocker = DragGesture()
    
    func sheet(_ sheet: Sheets) -> some View {
        switch sheet {
        case .saveStates(let game):
            return SaveStatesView(game: game).eraseToAny()
        case .addToPlaylist(let game):
            return AddToPlaylistView(game: game).eraseToAny()
        case .emulator:
            return SettingsStore.shared.swipeToDismiss ? (DeltaView {
                ActionCreator().presentMenu()
            }
            .edgesIgnoringSafeArea(.all)
            .actionSheet(isPresented: $navigation.isShowingEmulatorMenu) {
                ActionSheet.EmulatorMenu()
            }
            .eraseToAny()) : (DeltaView {
                ActionCreator().presentMenu()
            }
            .gesture(dragBlocker)
            .edgesIgnoringSafeArea(.all)
            .actionSheet(isPresented: $navigation.isShowingEmulatorMenu) {
                ActionSheet.EmulatorMenu()
            }
            .eraseToAny())
        case .lookup(let game):
            return WebView(url: .constant(URL(string: "https://www.google.com/search?q=\(String(game.title! + " " + game.type!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"))).edgesIgnoringSafeArea(.bottom).eraseToAny()
        case .none:
            return EmptyView().eraseToAny()
        }
    }
    
    func actionSheet(_ actionSheet: ActionSheets) -> ActionSheet {
        switch actionSheet {
        case .removeFromLibraryConfirmation(let game):
            return ActionSheet(title: Text("Are you sure you want to remove this game from your library?"), message: nil, buttons: [
                .destructive(Text("Delete Game")) {
                    game.deleteFromLibrary()
                },
                .cancel()
            ])
        case .removeSaveFromLibraryConfirmation(let save):
            return ActionSheet(title: Text("Are you sure you want to remove this save from your library?"), message: nil, buttons: [
                .destructive(Text("Delete Save State")) {
                    save.deleteFromLibrary()
                },
                .cancel()
            ])
        case .none:
            return ActionSheet(title: Text("Don't look, I'm naked!"))
        }
    }
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .actionSheet(item: $navigation.activeActionSheet) {
                self.actionSheet($0)
        }
        .sheet(item: $navigation.activeSheet) {
            self.sheet($0)
                .actionSheet(item: self.$navigation.activeActionSheet) {
                    self.actionSheet($0)
            }
            .environmentObject(NavigationStore.shared)
            .environment(\.managedObjectContext, self.context)
            .sheet(item: self.$navigation.activeSheetLayer2) {
                self.sheet($0)
                    .actionSheet(item: self.$navigation.activeActionSheet) {
                        self.actionSheet($0)
                }
                .environmentObject(NavigationStore.shared)
                .environment(\.managedObjectContext, self.context)
            }
        }
    }
}
