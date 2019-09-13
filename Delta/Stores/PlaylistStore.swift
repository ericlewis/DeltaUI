import SwiftUI

enum CollectionActions {
    case loadGames(CollectionEntity)
    case addGame(CollectionEntity, ItemEntity)
    case deleteGame(CollectionEntity, ItemEntity)
    case deletePlaylist(CollectionEntity)
}

extension ActionCreator where Actions == CollectionActions {
    func loadGames(_ playlist: CollectionEntity) {
        perform(.loadGames(playlist))
    }
    
    func deleteGame(_ playlist: CollectionEntity, _ game: ItemEntity) {
        perform(.deleteGame(playlist, game))
    }
    
    func deletePlaylist(_ playlist: CollectionEntity) {
        perform(.deletePlaylist(playlist))
    }
    
    func addGameToPlaylist(_ playlist: CollectionEntity, _ game: ItemEntity) {
        perform(.addGame(playlist, game))
    }
}

class CollectionStore: ObservableObject {
    static let shared = CollectionStore()

    @Published var games: [ItemEntity] = []

    init(dispatcher: Dispatcher<CollectionActions> = .shared) {
        dispatcher.register { [weak self] action in
            guard let `self` = self else {return}
            
            switch action {
            case .loadGames(let playlist):
                self.games = playlist.games?.allObjects as? [ItemEntity] ?? []
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
    private func addGame(_ playlist: CollectionEntity, _ game: ItemEntity) {
        playlist.addToGames(game)
        try? playlist.managedObjectContext?.save()
        
        // boo
        ActionCreator().dismiss()
    }
    
    private func deletePlaylist(_ playlist: CollectionEntity) {
        guard let context = playlist.managedObjectContext else {
            return
        }
        
        context.delete(playlist)
    }
    
    private func deleteGame(_ playlist: CollectionEntity, _ game: ItemEntity) {
        guard let idx = self.games.firstIndex(where: {
            $0.id == game.id
        }) else {
            return
        }
        
        playlist.removeFromGames(game)
        games.remove(at: idx)
    }
}
