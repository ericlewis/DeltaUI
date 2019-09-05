import CoreData
import DeltaCore

public class SaveStateEntity: NSManagedObject {}

extension SaveStateEntity {
  var gameType: GameType {
    .gba
  }
  
  var loadable: SaveState? {
    guard let url = fileURL else {return nil}
    
    return SaveState(fileURL: url, gameType: gameType)
  }
}
