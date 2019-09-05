import SwiftUI
import URLImage

struct SaveStatesView: View, StorageProtocol {
    @ObservedObject var game: GameEntity
    
    var body: some View {
        NavigationView {
            List {
                if game.saveState?.imageFileURL != nil {
                    VStack {
                        URLImage(imagesDir.appendingPathComponent(game.saveState!.imageFileURL!.lastPathComponent, isDirectory: false))
                        .resizable()
                        .scaledToFit()
                        Text(game.saveState!.createdAt!.description)
                    }
                }
            }
            .navigationBarTitle("Save States")
        }
    }
}
