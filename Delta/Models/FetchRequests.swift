import SwiftUI
import CoreData

typealias FetchedGames = FetchedResults<ItemEntity>

struct FetchRequests {
    
    // new new
    
    static func testGames() -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
    
    static func allFavorites() -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        request.predicate = NSPredicate(format: "favorited = YES")
        return request
    }
    
    static func allPlaylists() -> NSFetchRequest<CollectionEntity> {
        let request: NSFetchRequest<CollectionEntity> = CollectionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }

    static func allGames(console: Console, inLibrary: Bool = false) -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if console != .all && inLibrary {
            request.predicate = NSPredicate(format: "systemShort = %@ && rom != nil", console.rawValue)
        } else if console != .all {
            request.predicate = NSPredicate(format: "systemShort = %@", console.rawValue)
        } else if inLibrary {
            request.predicate = NSPredicate(format: "rom != nil", console.rawValue)
        }
                  
        return request
    }
    
    static func recentlyPlayed(console: Console, limit: Int = 6) -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastPlayed", ascending: false)]
        
        if console != .all {
            request.predicate = NSPredicate(format: "systemShort = %@", console.rawValue)
        }
        
        request.fetchLimit = limit
          
        return request
    }
    
    static func recentlyPlayedDetail(console: Console) -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if console != .all {
            request.predicate = NSPredicate(format: "systemShort = %@ & lastPlayed != nil", console.rawValue)
        } else {
            request.predicate = NSPredicate(format: "lastPlayed != nil")
        }
                  
        return request
    }
    
    static func recentlyAdded() -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "rom.createdAt", ascending: false)]
        request.predicate = NSPredicate(format: "rom != nil")
        request.fetchLimit = 6
          
        return request
    }
    
    static func recentlyAddedExtended() -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "rom.createdAt", ascending: false)]
        request.predicate = NSPredicate(format: "rom != nil")
        request.fetchLimit = 40
          
        return request
    }
}
