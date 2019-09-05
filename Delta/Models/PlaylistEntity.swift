import CoreData

extension PlaylistEntity {
  static func create(title: String, context: NSManagedObjectContext, callback: () -> Void) {
    if !title.isEmpty {
        let playlist = PlaylistEntity(context: context)
        playlist.id = UUID()
        playlist.title = title
        try? context.save()
    }
    
    callback()
  }
}
