import CoreData
import Files
import SwiftSoup
import DeltaCore

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey.init(rawValue: "managedObjectContext")!
}

@objc(GameEntity) public
class GameEntity: NSManagedObject, Codable, Identifiable {
  enum CodingKeys: String, CodingKey {
    case id, title, image, downloadURL, productURL, romName, type, lastPlayed, downloadedAt, favorited
  }
  
  @NSManaged public var id: String?
  @NSManaged public var title: String?
  @NSManaged public var image: URL?
  @NSManaged public var downloadURL: URL?
  @NSManaged public var productURL: URL?
  @NSManaged public var type: String?
  @NSManaged public var romName: String?
  @NSManaged public var lastPlayed: Date?
  @NSManaged public var downloadedAt: Date?
  @NSManaged public var favorited: Bool
  @NSManaged public var saveState: SaveStateEntity?
  
  public var romURL: URL? {
    if let romName = romName {
      var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      url.appendPathComponent(romName)
      return url
    }
    
    return nil
  }
  
  public required convenience init(from decoder: Decoder) throws {
    let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as! NSManagedObjectContext
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(String.self, forKey: .id)
    self.title = try container.decodeIfPresent(String.self, forKey: .title)
    self.image = try container.decodeIfPresent(URL.self, forKey: .image)
    self.downloadURL = try container.decodeIfPresent(URL.self, forKey: .downloadURL)
    self.productURL = try container.decodeIfPresent(URL.self, forKey: .productURL)
    self.romName = try container.decodeIfPresent(String.self, forKey: .romName)
    self.type = try container.decodeIfPresent(String.self, forKey: .type)
    self.lastPlayed = try container.decodeIfPresent(Date.self, forKey: .lastPlayed)
    self.downloadedAt = try container.decodeIfPresent(Date.self, forKey: .downloadedAt)
    self.favorited = try container.decodeIfPresent(Bool.self, forKey: .favorited) ?? false
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(image, forKey: .image)
    try container.encode(productURL, forKey: .productURL)
    try container.encode(downloadURL, forKey: .downloadURL)
    try container.encode(type, forKey: .type)
    try container.encode(romName, forKey: .romName)
    try container.encode(lastPlayed, forKey: .lastPlayed)
    try container.encode(downloadedAt, forKey: .downloadedAt)
    try container.encode(favorited, forKey: .favorited)
  }
}

extension GameEntity {
  var console: Console {
    return Console(rawValue: type!)!
  }
}

extension GameEntity {
  var hasROM: Bool {
    romURL != nil
  }
}

extension GameEntity {
  var splitTitle: (String?, String?) {
    if let splitTitle = title?.split(separator: "-"), let title = splitTitle.last, let subtitle = splitTitle.first {
      if splitTitle.count == 1 {
        return (self.title, nil)
      }
      
      return (String(title.trimmingCharacters(in: .whitespacesAndNewlines)), String(subtitle.trimmingCharacters(in: .whitespacesAndNewlines)))
    } else {
      return (nil, nil)
    }
  }
}

extension GameEntity {
  internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let progress = totalBytesExpectedToWrite / totalBytesWritten
    print(progress)
  }
  
  func download(callback: @escaping (URL) -> Void) {
    guard let url = downloadURL else {return}
    
    func download(with zipURL: URL) {
      URLSession.shared.downloadTask(with: zipURL) { localURL, _, _ in
        let dest = URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path + "/" + self.id!)
        try? FileManager().unzipItem(at: localURL!, to: dest)
        let first = try? Folder(path: dest.path).files.first
        let path = first?.path
        let url = URL(fileURLWithPath: path!)
        
        DispatchQueue.main.async {
          self.romName = self.id! + "/" + url.lastPathComponent
          self.downloadedAt = Date()
          try? self.managedObjectContext?.save()
          callback(url)
        }
      }
      .resume()
    }
    
    if url.pathExtension == "zip" {
      DispatchQueue.global(qos: .userInitiated).async {
        download(with: url)
      }
    } else {
      DispatchQueue.global(qos: .userInitiated).async {
        guard let html = try? String(contentsOf: url, encoding: .ascii) else {return}
        let doc = try? SwiftSoup.parse(html)
        guard let link = try? doc?.select("a.wait__link").first()?.attr("href") else {return}
        guard let linkURL = URL(string: link) else {return}
        
        if linkURL.pathExtension != "zip" {
          // throw an error
          return
        }
        
        download(with: linkURL)
      }
    }
  }
}

extension GameEntity {
  func updateLastPlayed() {
    lastPlayed = Date()
    try? managedObjectContext?.save()
  }
}

struct SearchResults: Codable {
  var results: [GameEntity]
}

extension GameEntity {
  var game: Game? {
    guard let url = romURL, let type = FileExts(rawValue: url.pathExtension)?.game else {return nil}
    return Game(fileURL: url, type: type)
  }
}

enum Console: String {
  case all
  case gba  = "gameboy-advance"
  case gbc  = "gameboy-color"
  case gb   = "gameboy"
  case nes  = "nintendo"
  case snes = "super-nintendo"
  
  var title: String {
    switch self {
    case .gba:
      return "Gameboy Advance"
    case .gbc:
      return "Gameboy Color"
    case .gb:
      return "Gameboy"
    case .nes:
      return "Nintendo"
    case .snes:
      return "Super Nintendo"
    case .all:
      return "Recently Played" // boo
    }
  }
}

enum FileExts: String {
  case gba, gb, gbc, nes, snes = "smc"
  
  var game: GameType {
    switch self {
    case .gba:
      return .gba
    case .nes:
      return .nes
    case .snes:
      return .snes
    case .gbc, .gb:
      return .gbc
    }
  }
}
