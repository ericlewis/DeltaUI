import SwiftUI
import SQLite

class VGDBStore: ObservableObject {
    static let shared = VGDBStore()
    
    private let db = try! Connection(Bundle.main.url(forResource: "openvgdb",
                                                     withExtension: "sqlite")!.path)
    private let roms = Table("ROMs")
    private let releases = Table("RELEASES")
    private let id = Expression<Int64>("romID")

    @Published var count = "0"
    
    init() {

    }
}
