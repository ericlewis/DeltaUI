import SwiftUI
import URLImage

struct SaveStateCell: View, StorageProtocol {
    var state: SaveEntity
    var auto = false
    var selected: (SaveEntity) -> Void
    
    let formatter = RelativeDateTimeFormatter()
    
    init(_ state: SaveEntity, auto: Bool = false, selected: @escaping (SaveEntity) -> Void) {
        self.state = state
        self.auto = auto
        self.selected = selected
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            URLImage(imagesDir.appendingPathComponent(state.image!.url!.lastPathComponent, isDirectory: false), placeholder: {
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
        .onTapGesture {
            self.selected(self.state)
        }
        .contextMenu {
            // TODO: move me
            Button(action: {
                 self.selected(self.state)
            }) {
                HStack {
                    Text("Load & Play")
                    Spacer()
                    Image(systemSymbol: .gamecontroller)
                }
            }
            if !auto {
                Button(action: ActionCreator().presentRemoveSaveFromLibraryConfirmation(state)) {
                    HStack {
                        Text("Delete Save")
                        Spacer()
                        Image(systemSymbol: .trash)
                    }
                }
            }
        }
    }
}
