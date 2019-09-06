import SwiftUI
import URLImage

struct SaveStatesView: View {
    @ObservedObject var game: GameEntity
    
    struct Cell: View, StorageProtocol {
        var state: SaveStateEntity
        var auto = false
        
        let formatter = RelativeDateTimeFormatter()
        
        init(_ state: SaveStateEntity, auto: Bool = false) {
            self.state = state
            self.auto = auto
        }
        
        var body: some View {
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
    
    var saves: [SaveStateEntity] {
        (game.saveStates?.allObjects as? [SaveStateEntity])?.reversed() ?? []
    }
    
    var body: some View {
        NavigationView {
            GridView(saves, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
              VStack(alignment: .leading) {
                Divider()
                if self.game.saveState != nil {
                    Cell(self.game.saveState!, auto: true)
                }
                Text("All Saves")
                  .font(.title)
                  .bold()
                  .padding(.top)
              }
            }) {
              Cell($0)
            }
            .padding(.horizontal)
            .navigationBarTitle("Save States")
            .navigationBarItems(trailing: Button(action: {}) {
                Text("Done").bold()
            })
        }
        .accentColor(.purple)
    }
}
