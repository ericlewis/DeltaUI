import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var url: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        return view
    }

    func updateUIView(_ view: WKWebView, context: Context) {
        guard let url = self.url else {
            return
        }

        view.allowsBackForwardNavigationGestures = true

        view.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.request.url?.pathExtension == "zip" {
                return decisionHandler(.cancel)
            }

            decisionHandler(.allow)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: .constant(nil))
    }
}
