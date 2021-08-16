import CoreData
import DeltaCore

@objc(FileEntity)
public class FileEntity: NSManagedObject, Identifiable {}

@objc(SaveEntity)
public class SaveEntity: FileEntity, SaveStateProtocol {
    public var fileURL: URL {
        get {
            url!
        }
        set {
            url = newValue
        }
    }
    
    public var gameType: GameType {
        GameType(rawValue: type!)
    }
}

extension SaveEntity {
    func deleteFromLibrary() {
        // TODO:
    }
}


@objc(ROMEntity)
public class ROMEntity: FileEntity, GameProtocol, StorageProtocol {
    public var fileURL: URL {
        get {
            var dir = gamesDir
            dir.appendPathComponent(url!.lastPathComponent)
            return dir
        }
        set {
            url = newValue
        }
    }
    
    public var type: GameType {
        game!.type
    }
}

@objc(ItemEntity)
public class ItemEntity: NSManagedObject, Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             details,
             developer,
             frontImageURL,
             backImageURL,
             crc,
             sha1,
             md5,
             regions,
             url,
             systemShort,
             genres,
             fileName
    }
    
    var task: DownloadTask?
    
    public required convenience init(from decoder: Decoder) throws {
        let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as! NSManagedObjectContext
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int32.self, forKey: .id)!
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.detail = try container.decodeIfPresent(String.self, forKey: .details)
        self.genres = try container.decodeIfPresent(String.self, forKey: .genres)
        self.developer = try container.decodeIfPresent(String.self, forKey: .developer)
        self.frontCovers = try container.decodeIfPresent(String.self, forKey: .frontImageURL)
        self.backCovers = try container.decodeIfPresent(String.self, forKey: .backImageURL)
        self.crc = try container.decodeIfPresent(String.self, forKey: .crc)
        self.sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        self.md5 = try container.decodeIfPresent(String.self, forKey: .md5)
        self.regions = try container.decodeIfPresent(String.self, forKey: .regions)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.systemShort = try container.decodeIfPresent(String.self, forKey: .systemShort)
        self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
    }
}

// TODO: these should be proper imports probably. with entities.
public extension ItemEntity {
    var genre: [String] {
        guard let genres = self.genres?.components(separatedBy: ",") else {
            return []
        }
        
        return genres.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var frontImageURL: [URL] {
        guard let images = self.frontCovers?.components(separatedBy: ",") else {
            return []
        }
        
        return images.compactMap {
            URL(string: $0)
        }
    }
    
    var backImageURL: [URL] {
        guard let images = self.backCovers?.components(separatedBy: ",") else {
            return []
        }
        
        return images.compactMap {
            URL(string: $0)
        }
    }
    
    var region: [String] {
        guard let regions = self.regions?.components(separatedBy: ",") else {
            return []
        }
        
        return regions.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    @objc func titleInitial() -> String {
        let startIndex = title!.startIndex
        let first = title![...startIndex]
        let string = String(first)
        
        if string.characterCount(for: .decimalDigits) > 0 {
            return "#"
        }
        
        return String(first)
    }
    
    var type: GameType {
        GameType(shortName: systemShort!)
    }
    
    var isDownloaded: Bool {
        rom != nil
    }
    
    var imageURL: URL? {
        frontImageURL.first ?? backImageURL.first
    }
}

extension ItemEntity {
    func updateLastPlayed() {
        
    }
    
    func deleteFromLibrary() {
        
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey.init(rawValue: "managedObjectContext")!
}

extension GameType {
    init(shortName: String) {
        self = Console(rawValue: shortName)!.type
    }
    
    var title: String {
        switch self {
        case .gba:
            return "Gameboy Advance"
        case .gbc:
            return "Gameboy Color"
        case .nes:
            return "Nintendo"
        case .snes:
            return "Nintendo"
        default:
            return "Unknown"
        }
    }
}

enum Console: String {
    case all
    case gba  = "GBA"
    case gbc  = "GBC"
    case gb   = "GB"
    case nes  = "NES"
    case snes = "SNES"
    
    var type: GameType {
        switch self {
        case .gba:
            return .gba
        case .gbc, .gb:
            return .gbc
        case .nes:
            return .nes
        case .snes:
            return .snes
        case .all:
            return .gba // DEFAULT
        }
    }
    
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
            return "Recently Played" // boo dont do this
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
