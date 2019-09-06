import SwiftUI
import DeltaCore

struct DeltaViewInner: UIViewControllerRepresentable {
    @Binding var game: GameEntity?
    @Binding var pause: Bool
    @Binding var saveState: Bool

    private var pressedMenu: () -> Void
    
    init(_ game: Binding<GameEntity?>, pause: Binding<Bool>, saveState: Binding<Bool>, pressedMenu: @escaping () -> Void) {
        _game = game
        _pause = pause
        _saveState = saveState
        self.pressedMenu = pressedMenu
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> OurGameViewController {
        let vc = OurGameViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ gameViewController: OurGameViewController, context: Context) {
        
        // fixes layout when rotating
        gameViewController.view.setNeedsUpdateConstraints()
        
        if saveState {
            print("save it!")
            gameViewController.persistSaveState()
            saveState = false
        }
        
        if pause {
            gameViewController.pauseEmulation()
        } else {
            gameViewController.resumeEmulation()
        }
        
        if game?.romURL == gameViewController.game?.fileURL {
            return
        }
        
        if let game = game {
            gameViewController.gameEnt = game
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
