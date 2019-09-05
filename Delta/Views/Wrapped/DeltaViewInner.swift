import SwiftUI
import DeltaCore

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
    
    func updateUIViewController(_ gameViewController: GameViewController, context: Context) {
        // fixes layout when rotating
        gameViewController.view.setNeedsUpdateConstraints()
        
        if let game = game {
            gameViewController.game = game.game
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
