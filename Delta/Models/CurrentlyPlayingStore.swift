import SwiftUI

class CurrentlyPlayingStore: ObservableObject {
    @Published var isShowingEmulator = false
    @Published var game: GameEntity? = nil

    func selectedGame(_ game: GameEntity) {
        self.game = game
        self.isShowingEmulator = true
        game.updateLastPlayed()
    }
    
}
