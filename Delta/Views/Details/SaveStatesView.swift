import SwiftUI
import URLImage

struct SaveStatesView: View {
    @ObservedObject var game: GameEntity
    var selected: (SaveStateEntity?) -> Void

    var saves: [SaveStateEntity] {
        (game.saveStates?.allObjects as? [SaveStateEntity])?.reversed() ?? []
    }
    
    var body: some View {
        NavigationView {
            GridView(saves, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
              VStack(alignment: .leading) {
                Divider()
                if self.game.saveState != nil {
                    SaveStateCell(self.game.saveState!, auto: true, selected: {
                        let v = $0
                        v.extraGame = self.game
                        self.selected(v)
                    })
                }
                Text("All Saves")
                  .font(.title)
                  .bold()
                  .padding(.top)
              }
            }) {
                SaveStateCell($0, auto: false, selected: {
                    let v = $0
                    v.extraGame = self.game
                    self.selected(v)
                })
            }
            .padding(.horizontal)
            .navigationBarTitle("Save States")
            .navigationBarItems(trailing: Button(action: {
                self.selected(nil)
            }) {
                Text("Done").bold()
            })
        }
        .accentColor(.purple)
    }
}

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
