import SwiftUI

extension View {
    func eraseToAny() -> AnyView {
        AnyView(self)
    }
}
