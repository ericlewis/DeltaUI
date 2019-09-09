import SwiftUI

struct DoneButton: View {
    var body: some View {
        Button(action: ActionCreator().dismiss) {
          Text("Done")
          .done()
        }
    }
}

struct DoneButton_Previews: PreviewProvider {
    static var previews: some View {
        DoneButton()
    }
}
