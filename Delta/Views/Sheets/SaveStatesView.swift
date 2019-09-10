import SwiftUI

struct SaveStatesView: View {
    @ObservedObject var store = SaveStatesStore.shared
    @ObservedObject var game: ItemEntity

    func selected(_ save: SaveEntity) {
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
                    $0.image != nil
                }, columns: 2, columnsInLandscape: 3, vSpacing: 15, hPadding: 0, header: {
              VStack(alignment: .leading) {
                Divider()
                // TODO: show auto save
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
