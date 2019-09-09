import SwiftUI

enum CollectionActions {
    case loadGames(PlaylistEntity)
    case addGame(PlaylistEntity, GameEntity)
    case deleteGame(PlaylistEntity, GameEntity)
    case deletePlaylist(PlaylistEntity)
}

extension ActionCreator where Actions == CollectionActions {
    func loadGames(_ playlist: PlaylistEntity) {
        perform(.loadGames(playlist))
    }
    
    func deleteGame(_ playlist: PlaylistEntity, _ game: GameEntity) {
        perform(.deleteGame(playlist, game))
    }
    
    func deletePlaylist(_ playlist: PlaylistEntity) {
        perform(.deletePlaylist(playlist))
    }
    
    func addGameToPlaylist(_ playlist: PlaylistEntity, _ game: GameEntity) {
        perform(.addGame(playlist, game))
    }
}

class CollectionStore: ObservableObject {
    static let shared = CollectionStore()

    @Published var games: [GameEntity] = []

    init(dispatcher: Dispatcher<CollectionActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .loadGames(let playlist):
                self.games = playlist.games?.allObjects as? [GameEntity] ?? []
            case .addGame(let playlist, let game):
                self.addGame(playlist, game)
            case .deleteGame(let playlist, let game):
                self.deleteGame(playlist, game)
            case .deletePlaylist(let playlist):
                self.deletePlaylist(playlist)
                self.games = []
            }
        }
    }
}

extension CollectionStore {
    private func addGame(_ playlist: PlaylistEntity, _ game: GameEntity) {
        playlist.addToGames(game)
        try? playlist.managedObjectContext?.save()
        
        // boo
        ActionCreator().dismiss()
    }
    
    private func deletePlaylist(_ playlist: PlaylistEntity) {
        guard let context = playlist.managedObjectContext else {
            return
        }
        
        context.delete(playlist)
    }
    
    private func deleteGame(_ playlist: PlaylistEntity, _ game: GameEntity) {
        guard let idx = self.games.firstIndex(where: {
            $0.id == game.id
        }) else {
            return
        }
        
        playlist.removeFromGames(game)
        games.remove(at: idx)
    }
}
