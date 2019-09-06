import SwiftUI

struct DeltaView: View {
  @EnvironmentObject var store: CurrentlyPlayingStore
  @ObservedObject var menu = MenuStore()
  
  @State var saveState = false
    
  let gesture = DragGesture()
  
  var body: some View {
    EmptyView().sheet(isPresented: $store.isShowingEmulator) {
        DeltaViewInner(self.$store.game, pause: self.$menu.isShowing, saveState: self.$saveState, loadSaveState: self.$store.loadSaveState) {
        self.menu.isShowing.toggle()
      }
      .edgesIgnoringSafeArea(.all)
      .sheet(isPresented: self.$menu.isShowingAddToPlaylist) {
        if self.menu.isShowingSavedStates {
            SaveStatesView(game: self.store.game!) {
                self.menu.isShowingAddToPlaylist = false
                self.menu.isShowingSavedStates = false
                self.store.selectedSave($0)
            }
        } else {
            AddToPlaylist(isShowing: self.$menu.isShowingAddToPlaylist, game: self.store.game!)
            .environment(\.managedObjectContext, self.store.game!.managedObjectContext!)
        }
      }
      .actionSheet(isPresented: self.$menu.isShowing) {
        ActionSheet.EmulatorMenu(store: self.store, menu: self.menu) {
            self.saveState.toggle()
        }
      }
      .highPriorityGesture(self.gesture) // i keep the modal open
    }
}
}
