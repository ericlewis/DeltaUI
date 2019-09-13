import DeltaCore
import Files
import Combine

extension Notification.Name {
    static let myExampleNotification = Notification.Name("an-example-notification")
}

class OurGameViewController: GameViewController, StorageProtocol {
    
    var gameEnt: ItemEntity?
    
    var stateToLoad: SaveEntity? {
        didSet {
            let state = self.stateToLoad
            if gameEnt != nil && state != nil {
                try? emulatorCore?.load(state!)
            }
        }
    }
    
    private let imageContext = CIContext(options: [.workingColorSpace: NSNull()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmulatorStore.shared.save = { [weak self] in
            self?.persistSaveState()
        }
        
        EmulatorStore.shared.load = { [weak self] state in
            self?.stateToLoad = state
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resumeEmulation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.loadState()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stateToLoad = nil
        persistAutoSaveState()
    }
    
    private func setupGame() {
        guard let game = gameEnt?.rom else {
            return
        }
        
        self.game = game
    }

    private func loadState() {
//        do {
//            let isRunning = (emulatorCore?.state == .running)
//
//            if isRunning {
//                pauseEmulation()
//            }
//
//            guard let save = gameEnt?.saveState?.loadable else {
//                if isRunning {
//                    resumeEmulation()
//                }
//
//                return
//            }
//
//            if self.stateToLoad != nil {
//                try emulatorCore?.load(self.stateToLoad!.loadableWithGame(gameEnt!)!)
//            } else if SettingsStore.shared.resumeFromAutoSave {
//                try emulatorCore?.load(save)
//            }
//
//            if isRunning {
//                resumeEmulation()
//            }
//
//        } catch {
//            print(error)
//            resumeEmulation()
//        }
    }
    
    private func persistAutoSaveState() {
//        if SettingsStore.shared.autoSaveOnClose {
//            guard let save = createSaveStateEntity(), let context = gameEnt?.managedObjectContext else {return}
//            // createSaveImage(save)
//            // gameEnt?.saveState = save
//            try? context.save()
//        }
    }
    
    func persistSaveState() {
        guard let save = createSaveStateEntity(false), let context = gameEnt?.managedObjectContext else {return}
        createSaveImage(save)
        try? context.save()
        ActionCreator().saveComplete(gameEnt!, save.image!.url!) // bad spot for it
    }
    
    private func createSaveImage(_ save: SaveEntity) {
        if let outputImage = gameView.outputImage,
           let quartzImage = imageContext.createCGImage(outputImage, from: outputImage.extent),
           let data = UIImage(cgImage: quartzImage).pngData() {
            do {
                let url = newImageFile()
                try data.write(to: url, options: [.atomicWrite])
                let imageEnt = ImageEntity(context: gameEnt!.managedObjectContext!)
                imageEnt.id = UUID()
                imageEnt.save = save
                imageEnt.url = url
                save.image = imageEnt
            }
            catch {
                print(error)
            }
        }
    }
    
    private func createSaveStateEntity(_ connected: Bool = true) -> SaveEntity? {
        guard let gameEnt = self.gameEnt else {
            return nil
        }

        let url = saveStatesDir(for: gameEnt).appendingPathComponent(UUID().uuidString, isDirectory: false)
        guard let saveState = emulatorCore?.saveSaveState(to: url) else {
            return nil
        }
        
        let save = SaveEntity(context: gameEnt.managedObjectContext!)
        save.id = UUID()
        save.fileURL = saveState.fileURL
        save.type = saveState.gameType.rawValue
        save.game = gameEnt

        return save
    }
}
