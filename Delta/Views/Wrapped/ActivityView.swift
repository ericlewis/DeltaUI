import SwiftUI

struct ActivityView: UIViewRepresentable {
    var color: UIColor = .systemGray
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.color = color
        uiView.startAnimating()
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
