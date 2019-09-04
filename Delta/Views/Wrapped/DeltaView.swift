import SwiftUI
import DeltaCore

struct DeltaView: View {
    @EnvironmentObject var store: CurrentlyPlayingStore
    @ObservedObject var menu = MenuStore()
    
    let gesture = DragGesture()
    
    var body: some View {
        EmptyView().sheet(isPresented: $store.isShowingEmulator) {
            DeltaViewInner(self.$store.game) {
                self.menu.isShowing.toggle()
            }
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: self.$menu.isShowingAddToPlaylist) {
                AddToPlaylist(isShowing: self.$menu.isShowingAddToPlaylist, game: self.store.game!)
                    .environment(\.managedObjectContext, self.store.game!.managedObjectContext!)
            }
            .actionSheet(isPresented: self.$menu.isShowing) {
                ActionSheet(title: Text("Menu"), message: nil, buttons: [
                    self.store.game!.favorited ? .default(Text("Unfavorite")) {
                        self.store.game?.favorited.toggle()
                        } : .default(Text("Favorite")) {
                            self.store.game?.favorited.toggle()
                    },
                    .default(Text("Add to Playlist")) {
                        self.menu.isShowingAddToPlaylist.toggle()
                    },
                    .destructive(Text("Close \(self.store.game!.console.title)")) {
                        self.store.isShowingEmulator.toggle()
                    },
                    .cancel()
                ])
            }
            .highPriorityGesture(self.gesture)
        }
    }
}

struct DeltaViewInner: UIViewControllerRepresentable {
    @Binding var game: GameEntity?
    
    private var pressedMenu: () -> Void
    
    init(_ game: Binding<GameEntity?>, pressedMenu: @escaping () -> Void) {
        _game = game
        self.pressedMenu = pressedMenu
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> GameViewController {
        let vc = GameViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        uiViewController.view.setNeedsUpdateConstraints()
        if let game = game {
            uiViewController.game = game.game
        }
    }
    
    class Coordinator: NSObject, GameViewControllerDelegate {
        var parent: DeltaViewInner
        
        init(_ parent: DeltaViewInner) {
            self.parent = parent
        }
        
        func gameViewController(_ gameViewController: GameViewController, handleMenuInputFrom gameController: GameController) {
            parent.pressedMenu()
        }
    }
}
