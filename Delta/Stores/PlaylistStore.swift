import SwiftUI

class PlaylistStore: ObservableObject {
  @Published var playlist: PlaylistEntity
  @Published var games: [GameEntity] = []
    
  init(_ playlist: PlaylistEntity) {
    self.playlist = playlist
    games = self.playlist.games?.allObjects as? [GameEntity] ?? []
  }
  
  func delete(_ index: IndexSet) {
    let idx = index.first!
    let game = games[idx]
    playlist.removeFromGames(game)
    try? game.managedObjectContext?.save()
    games.remove(at: idx)
  }
  
}
