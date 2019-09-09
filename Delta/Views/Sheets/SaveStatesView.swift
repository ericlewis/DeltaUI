import SwiftUI

struct SaveStatesView: View {
    @ObservedObject var store = SaveStatesStore.shared
    @ObservedObject var game: GameEntity

    func selected(_ save: SaveStateEntity) {
        // FIX THIS CRAP, and by fix, i mean put in an ActionCreator
        
        ActionCreator().dismiss()
        
        switch NavigationStore.shared.activeSheet {
        case .emulator(_):
            ActionCreator().loadState(save)
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ActionCreator().presentEmulator(self.game)()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    ActionCreator().loadState(save)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GridView(store.saves.filter {
                    $0.imageFileURL != nil
                }, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
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
        .onAppear {
            ActionCreator().loadSaveStates(self.game)
        }
    }
}
