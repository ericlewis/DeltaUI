import SwiftUI
import DeltaCore

struct DeltaViewInner: UIViewControllerRepresentable {
    @Binding var game: GameEntity?
    @Binding var pause: Bool

    private var pressedMenu: () -> Void
    
    init(_ game: Binding<GameEntity?>, pause: Binding<Bool>, pressedMenu: @escaping () -> Void) {
        _game = game
        _pause = pause
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
        
        if pause {
            gameViewController.pauseEmulation()
        } else {
            gameViewController.resumeEmulation()
        }
        
        if game?.romURL == gameViewController.game?.fileURL {
            return
        }
        
        if let game = game {
            gameViewController.game = game.game
            
            // hack. remove me once you figure out lifecycle issues.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                do {
                    let isRunning = (gameViewController.emulatorCore?.state == .running)
                    
                    if isRunning {
                        gameViewController.pauseEmulation()
                    }
                    
                    guard let save = game.saveState?.loadable else {return}
                    print(save)
                    try gameViewController.emulatorCore?.load(save)
                    
                    if isRunning {
                        gameViewController.resumeEmulation()
                    }
                    
                } catch {
                    print(error)
                    gameViewController.resumeEmulation()
                }
            }
        }
    }
    
    class Coordinator: NSObject, GameViewControllerDelegate {
        var parent: DeltaViewInner
        
        init(_ parent: DeltaViewInner) {
            self.parent = parent
        }
        
        func gameViewController(_ gameViewController: GameViewController, handleMenuInputFrom gameController: GameController) {
            
            let context = parent.game!.managedObjectContext!
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: false)
            let saveState = gameViewController.emulatorCore?.saveSaveState(to: url)
            let ooo = SaveStateEntity(context: context)
            ooo.fileURL = saveState?.fileURL
            ooo.type = parent.game?.game?.type.rawValue
            ooo.game = parent.game
            try? context.save()
            
            parent.pressedMenu()
        }
    }
}
