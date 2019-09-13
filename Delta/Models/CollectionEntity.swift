import CoreData

extension CollectionEntity {
  static func create(title: String, context: NSManagedObjectContext, callback: () -> Void) {
    if !title.isEmpty {
        let playlist = CollectionEntity(context: context)
        playlist.id = UUID()
        playlist.title = title
        try? context.save()
    }
    
    callback()
  }
}
