import Foundation

extension String {
    var searchify: String {
        self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
