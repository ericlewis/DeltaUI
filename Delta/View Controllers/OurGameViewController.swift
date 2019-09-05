import DeltaCore

class OurGameViewController: GameViewController, StorageProtocol {
    
    var gameEnt: GameEntity?
    
    private let imageContext = CIContext(options: [.workingColorSpace: NSNull()])

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        persistState()
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
                return
            }
            
            try emulatorCore?.load(save)
            
            if isRunning {
                resumeEmulation()
            }
            
        } catch {
            print(error)
            resumeEmulation()
        }
    }
    
    private func persistState() {
        guard let gameEnt = self.gameEnt, let context = gameEnt.managedObjectContext,
              let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let url = dir.appendingPathComponent(UUID().uuidString, isDirectory: false)
        
        guard let saveState = emulatorCore?.saveSaveState(to: url) else {
            return
        }
        
        let save = SaveStateEntity.SaveState(game: gameEnt, saveState: saveState)
                
        if let outputImage = gameView.outputImage,
           let quartzImage = imageContext.createCGImage(outputImage, from: outputImage.extent),
           let data = UIImage(cgImage: quartzImage).pngData() {
            do {
                let url = newImageFile()
                save.imageFileURL = url
                try data.write(to: url, options: [.atomicWrite])
            }
            catch {
                print(url)
                print(error)
            }
        }
        
        try? context.save()
    }
}
