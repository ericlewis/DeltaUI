import SwiftUI
import URLImage

struct SaveStateCell: View, StorageProtocol {
    var state: SaveStateEntity
    var auto = false
    var selected: (SaveStateEntity) -> Void
    
    let formatter = RelativeDateTimeFormatter()
    
    init(_ state: SaveStateEntity, auto: Bool = false, selected: @escaping (SaveStateEntity) -> Void) {
        self.state = state
        self.auto = auto
        self.selected = selected
    }
    
    var body: some View {
        Button(action: {
            self.selected(self.state)
        }) {
            ZStack(alignment: .bottomLeading) {
                URLImage(imagesDir.appendingPathComponent(state.imageFileURL!.lastPathComponent, isDirectory: false), placeholder: {
                    Rectangle()
                })
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.secondary.opacity(0.6)))
                .scaleEffect(0.99)
                    .overlay(LinearGradient(gradient: Gradient(colors: [.clear, .secondary]), startPoint: .top, endPoint: .bottom).opacity(0.5)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous)))
                Text((auto ? "Auto Save • " : "") + formatter.localizedString(for: state.createdAt!, relativeTo: Date()))
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .padding()
                .shadow(radius: 2)
            }
        }
    }
}
