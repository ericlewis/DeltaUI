import SwiftUI

protocol TextStyle: ViewModifier {}

struct TitleStyle: TextStyle {
    func body(content: Content) -> some View {
        content
            .font(.title)
    }
}

extension Text {
    func textStyle<Style: TextStyle>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
