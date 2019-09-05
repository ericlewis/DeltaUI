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
    func createDir(url: URL) -> URL
}

extension StorageProtocol {
    var defaultDir: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var gamesDir: URL {
        createDir(url: defaultDir.appendingPathComponent("Games"))
    }
    
    var saveStatesDir: URL {
        createDir(url: defaultDir.appendingPathComponent("SaveStates"))
    }
    
    var imagesDir: URL {
        createDir(url: defaultDir.appendingPathComponent("Images"))
    }
    
    func saveStatesDir(for game: GameEntity) -> URL {
        // bug, this should be the game id, but it doesn't work correctly.
        saveStatesDir
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
    
    func createDir(url: URL) -> URL {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print(error)
        }
        
        return url
    }
}
