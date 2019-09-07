import DeltaCore
import Files

extension Notification.Name {
    static let myExampleNotification = Notification.Name("an-example-notification")
}

class OurGameViewController: GameViewController, StorageProtocol {
    
    var gameEnt: GameEntity?
    
    var stateToLoad: SaveStateEntity? {
        didSet {
            let state = self.stateToLoad
            if gameEnt != nil && state != nil {
                try? emulatorCore?.load(state!.loadableWithGame(gameEnt!)!)
            }
        }
    }
    
    private let imageContext = CIContext(options: [.workingColorSpace: NSNull()])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupGame()
//         loadState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resumeEmulation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stateToLoad = nil
//        persistAutoSaveState()
    }
    
    private func setupController() {
        guard let type = gameEnt?.game?.type else {
            return
        }
        
        self.controllerView.controllerSkin = ControllerSkin.standardControllerSkin(for: type)
    }
    
    private func setupGame() {
        guard let game = gameEnt?.game else {
            return
        }
        
        self.game = game
    }

    private func loadState() {
        do {
            let isRunning = (emulatorCore?.state == .running)
            
            if isRunning {
                pauseEmulation()
            }
            
            guard let save = gameEnt?.saveState?.loadable else {
                if isRunning {
                    resumeEmulation()
                }
                
                return
            }
            
            if self.stateToLoad != nil {
                try emulatorCore?.load(self.stateToLoad!.loadableWithGame(gameEnt!)!)
            } else {
                try emulatorCore?.load(save)
            }
            
            if isRunning {
                resumeEmulation()
            }
            
        } catch {
            print(error)
            resumeEmulation()
        }
    }
    
    private func persistAutoSaveState() {
        guard let save = createSaveStateEntity(), let context = gameEnt?.managedObjectContext else {return}
        createSaveImage(save)
        gameEnt?.saveState = save
        try? context.save()
    }
    
    func persistSaveState() {
        guard let save = createSaveStateEntity(false), let context = gameEnt?.managedObjectContext else {return}
        createSaveImage(save)
        gameEnt?.addToSaveStates(save)
        try? context.save()
    }
    
    private func createSaveImage(_ save: SaveStateEntity) {
        if let outputImage = gameView.outputImage,
           let quartzImage = imageContext.createCGImage(outputImage, from: outputImage.extent),
           let data = UIImage(cgImage: quartzImage).pngData() {
            do {
                let url = newImageFile()
                try data.write(to: url, options: [.atomicWrite])
                save.imageFileURL = url
            }
            catch {
                print(error)
            }
        }
    }
    
    private func createSaveStateEntity(_ connected: Bool = true) -> SaveStateEntity? {
        guard let gameEnt = self.gameEnt else {
            return nil
        }
        
        let url = saveStatesDir(for: gameEnt).appendingPathComponent(UUID().uuidString, isDirectory: false)
        guard let saveState = emulatorCore?.saveSaveState(to: url) else {
            return nil
        }
        
        return SaveStateEntity.SaveState(game: gameEnt, saveState: saveState, connected: connected)
    }
}
