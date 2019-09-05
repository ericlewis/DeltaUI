import CoreData
import DeltaCore

@objc(SaveStateEntity)
public class SaveStateEntity: NSManagedObject {}

extension SaveStateEntity {
  var gameType: GameType {
    GameType(type!)
  }
  
  var loadable: SaveState? {
    guard let url = fileURL else {return nil}
    
    return SaveState(fileURL: url, gameType: gameType)
  }
}
