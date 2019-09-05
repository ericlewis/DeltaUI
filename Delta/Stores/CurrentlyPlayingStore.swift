import SwiftUI

class CurrentlyPlayingStore: ObservableObject {
    @Published var isShowingEmulator = false
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
          game.download(callback: { _ in
            
          })
        }
      }
      
      return selected
    }
    
}
