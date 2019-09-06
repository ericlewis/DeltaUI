import SwiftUI
import CoreData

typealias FetchedGames = FetchedResults<GameEntity>

struct FetchRequests {
    static func allFavorites() -> NSFetchRequest<GameEntity> {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = NSPredicate(format: "favorited = YES")
        return request
    }
    
    static func allPlaylists() -> NSFetchRequest<PlaylistEntity> {
        let request: NSFetchRequest<PlaylistEntity> = PlaylistEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }

    static func allGames(console: Console, inLibrary: Bool = false) -> NSFetchRequest<GameEntity> {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if console != .all && inLibrary {
            request.predicate = NSPredicate(format: "type = %@ && romName != nil", console.rawValue)
        } else if console != .all {
            request.predicate = NSPredicate(format: "type = %@", console.rawValue)
        } else if inLibrary {
            request.predicate = NSPredicate(format: "romName != nil", console.rawValue)
        }
                  
        return request
    }
    
    static func recentlyPlayed(console: Console, limit: Int = 6) -> NSFetchRequest<GameEntity> {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastPlayed", ascending: false)]
        
        if console != .all {
            request.predicate = NSPredicate(format: "type = %@", console.rawValue)
        }
        
        request.fetchLimit = limit
          
        return request
    }
    
    static func recentlyPlayedDetail(console: Console) -> NSFetchRequest<GameEntity> {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if console != .all {
            request.predicate = NSPredicate(format: "type = %@", console.rawValue)
        }
                  
        return request
    }
    
    static func recentlyAdded() -> NSFetchRequest<GameEntity> {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "downloadedAt", ascending: false)]
        request.predicate = NSPredicate(format: "downloadedAt != nil")
        request.fetchLimit = 40
          
        return request
    }
}
