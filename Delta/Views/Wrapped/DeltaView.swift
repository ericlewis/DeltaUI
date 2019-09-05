import SwiftUI

struct DeltaView: View {
  @EnvironmentObject var store: CurrentlyPlayingStore
  @ObservedObject var menu = MenuStore()
  
  let gesture = DragGesture()
  
  var body: some View {
    EmptyView().sheet(isPresented: $store.isShowingEmulator) {
      DeltaViewInner(self.$store.game) {
        self.menu.isShowing.toggle()
      }
      .edgesIgnoringSafeArea(.all)
      .sheet(isPresented: self.$menu.isShowingAddToPlaylist) {
        AddToPlaylist(isShowing: self.$menu.isShowingAddToPlaylist, game: self.store.game!)
          .environment(\.managedObjectContext, self.store.game!.managedObjectContext!)
      }
      .actionSheet(isPresented: self.$menu.isShowing) {
        ActionSheet.EmulatorMenu(store: self.store, menu: self.menu)
      }
      .highPriorityGesture(self.gesture) // i keep the modal open
    }
  }
}
