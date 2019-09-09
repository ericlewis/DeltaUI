import SwiftUI

protocol ImageStyle: ViewModifier {}

extension Image {
    func imageStyle<Style: ImageStyle>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
