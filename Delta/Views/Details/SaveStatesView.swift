import SwiftUI

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
