import CoreData
import DeltaCore

@objc(SaveStateEntity)
public class SaveStateEntity: NSManagedObject, StorageProtocol {}

extension SaveStateEntity {
    static func SaveState(game: GameEntity, saveState: SaveStateProtocol) -> Self {
        let ctx = game.managedObjectContext!
        let save = self.init(context: ctx)
        
        save.fileURL = saveState.fileURL
        save.type = game.game?.type.rawValue
        save.game = game
        try? ctx.save()
        
        return save
    }
    
    var gameType: GameType {
        GameType(type!)
    }
    
    var loadable: DeltaCore.SaveState? {
        guard let url = fileURL, let game = self.game else {return nil}
        return DeltaCore.SaveState(fileURL: saveStatesDir(for: game).appendingPathComponent(url.lastPathComponent, isDirectory: false),
                                   gameType: gameType)
    }
}
