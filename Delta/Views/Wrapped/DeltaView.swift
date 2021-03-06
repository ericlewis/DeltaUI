import SwiftUI
import DeltaCore

struct DeltaView: UIViewControllerRepresentable {
    @EnvironmentObject var navigation: NavigationStore
    
    var pressedMenu: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> OurGameViewController {
        let vc = OurGameViewController()
        vc.delegate = context.coordinator
        vc.gameEnt = navigation.currentGame
        return vc
    }
    
    func updateUIViewController(_ gameViewController: OurGameViewController, context: Context) {
        
        // fixes layout when rotating
        gameViewController.view.setNeedsUpdateConstraints()
        gameViewController.gameEnt = navigation.currentGame
    }
    
    class Coordinator: NSObject, GameViewControllerDelegate {
        var parent: DeltaView
        
        init(_ parent: DeltaView) {
            self.parent = parent
        }
        
        func gameViewController(_ gameViewController: GameViewController, handleMenuInputFrom gameController: GameController) {
            parent.pressedMenu()
        }
    }
}
