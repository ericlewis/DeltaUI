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
    square()
    .mask(RoundedRectangle(cornerRadius: 4, style: .continuous))
    .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).stroke(Color.secondary.opacity(0.5)))
    .scaleEffect(0.99)
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
      .mask(RoundedRectangle(cornerRadius: 3, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(Color.secondary.opacity(0.5)))
  }
}
