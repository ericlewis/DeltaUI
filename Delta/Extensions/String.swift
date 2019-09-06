import Foundation

extension String {
    var searchify: String {
        self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
  func characterCount(for set: CharacterSet) -> Int {
    return self.unicodeScalars.filter({ set.contains($0) }).count
  }
}
