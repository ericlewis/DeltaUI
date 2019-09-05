import Foundation

protocol StorageProtocol {
    var defaultDir: URL {get}
    var gamesDir: URL {get}
    var saveStatesDir: URL {get}
    var imagesDir: URL {get}
    
    func saveStatesDir(for: GameEntity) -> URL
    func gameDir(for: GameEntity) -> URL
    func newSaveStatesFile(for: GameEntity) -> URL
    func newImageFile() -> URL
}

extension StorageProtocol {
    var defaultDir: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var gamesDir: URL {
        defaultDir.appendingPathComponent("Games")
    }
    
    var saveStatesDir: URL {
        defaultDir.appendingPathComponent("Save States")
    }
    
    var imagesDir: URL {
        defaultDir.appendingPathComponent("Images")
    }
    
    func saveStatesDir(for game: GameEntity) -> URL {
        saveStatesDir.appendingPathComponent(game.id!)
    }
    
    func gameDir(for game: GameEntity) -> URL {
        gamesDir.appendingPathComponent(game.id!, isDirectory: true)
    }

    func newSaveStatesFile(for game: GameEntity) -> URL {
        saveStatesDir(for: game).appendingPathComponent(UUID().uuidString, isDirectory: false)
    }
    
    func newImageFile() -> URL {
        imagesDir.appendingPathComponent(UUID().uuidString, isDirectory: false)
    }
}
