import SwiftUI

class CurrentlyPlayingStore: ObservableObject {
    @Published var isShowingEmulator = false
    @Published var loadSaveState: SaveStateEntity?
    @Published var game: GameEntity? = nil

    func selectedGame(_ game: GameEntity) {
        if game.hasROM {
          self.game = game
          self.isShowingEmulator = true
          game.updateLastPlayed()
        }
    }
  
    func selected(_ game: GameEntity) -> () -> Void {
      func selected() {        
        if game.hasROM {
          self.game = game
          self.isShowingEmulator = true
          game.updateLastPlayed()
        } else {
          game.download()
        }
      }
      
      return selected
    }
    
    func selectedSave(_ save: SaveStateEntity?) {
        if game == nil || isShowingEmulator == false {
            // no game currently playing, so lets wait. then load the saved game in.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let savedStateGame = save?.extraGame {
                     self.loadSaveState = save
                     self.selected(savedStateGame)()
                }
            }
        } else {
            loadSaveState = save
        }
    }
    
}
