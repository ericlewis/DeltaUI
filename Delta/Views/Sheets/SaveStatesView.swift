import SwiftUI

struct SaveStatesView: View {
    @ObservedObject var game: GameEntity

    var saves: [SaveStateEntity] {
        (game.saveStates?.allObjects as? [SaveStateEntity])?.reversed() ?? []
    }
    
    func selected(_ save: SaveStateEntity) {
        ActionCreator().loadState(save)
        ActionCreator().dismiss()
        
        // check if we already have the emulator displaying somewhere
    }
    
    var body: some View {
        NavigationView {
            GridView(saves, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
              VStack(alignment: .leading) {
                Divider()
                if self.game.saveState != nil {
                    SaveStateCell(self.game.saveState!, auto: true, selected: self.selected)
                }
                Text("All Saves")
                  .font(.title)
                  .bold()
                  .padding(.top)
              }
            }) {
                SaveStateCell($0, auto: false, selected: self.selected)
            }
            .padding(.horizontal)
            .navigationBarTitle("Save States")
            .navigationBarItems(trailing: Button(action: ActionCreator().dismiss) {
                Text("Done").bold()
            })
        }
        .accentColor(.purple)
    }
}
