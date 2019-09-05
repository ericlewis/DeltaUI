import SwiftUI
import WebKit

struct WebViewChrome: View {
    @State var urlInput = "https://google.com"
    @State var currentURL: URL? = URL(string: "https://google.com")
    @State var files: [URL] = []
    
    var body: some View {
        VStack {
            HStack {
                TextField("URL", text: $urlInput, onEditingChanged: { _ in
                    self.currentURL = URL(string: self.urlInput)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                if files.count > 0 {
                    Image(systemSymbol: .icloudAndArrowDown)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            Divider()
            WebView(url: $currentURL, files: $files)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct WebView: UIViewRepresentable {
    @Binding var url: URL?
    @Binding var files: [URL]
    
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
                if let fileName = navigationAction.request.url {
                    parent.files.append(fileName)
                }
                
                return decisionHandler(.cancel)
            }
            
            decisionHandler(.allow)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WebViewChrome()
        }
    }
}
