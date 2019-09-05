import SwiftUI
import URLImage

extension URLImage {
  func square() -> some View {
    self.renderingMode(.original)
      .resizable()
      .aspectRatio(1, contentMode: .fit)
  }
}

extension URLImage {
  func gameGridImage() -> some View {
    square().mask(RoundedRectangle(cornerRadius: 5))
  }
}

extension Text {
  func gameGridTitle() -> some View {
    self.foregroundColor(.primary)
      .lineLimit(1)
  }
  
  func gameGridSubtitle() -> some View {
    self.foregroundColor(.secondary)
      .lineLimit(1)
  }
  
  func done() -> some View {
    self.foregroundColor(.accentColor).bold()
  }
}

extension URLImage {
  func gameListImage() -> some View {
    self.square()
      .foregroundColor(.accentColor)
      .frame(width: 80, height: 80)
      .mask(RoundedRectangle(cornerRadius: 3))
  }
}
