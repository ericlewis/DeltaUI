import SwiftUI

struct PlaceholderView: View {
    var cornerRadius: CGFloat = 5.0
  
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.secondary)
                .aspectRatio(1, contentMode: .fit)
            ActivityView(color: .white)
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
    }
}
