import SwiftUI
import WebKit
import Files
import CoreData
import CryptoSwift

struct WebView: UIViewRepresentable {
    var game: ItemEntity
    var context: NSManagedObjectContext

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        return view
    }

    func updateUIView(_ view: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.google.com/search?q=\(String(game.title! + " " + game.type.title + " rom").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") else {
            return
        }

        view.allowsBackForwardNavigationGestures = true

        view.load(URLRequest(url: url))
    }

    class Coordinator: NSObject, WKNavigationDelegate, StorageProtocol {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            // application/x-7z-compressed
            if navigationResponse.response.mimeType == "application/zip" {
                guard let url = navigationResponse.response.url else {
                    return
                }
                
                // downloads and imports
                let _ = DownloadStore.shared.download(url: url, progress: {
                    print($0)
                }) { (error, url) in
                    guard error == nil, let url = url else {
                        return
                    }
                                            
                    try? FileManager().unzipItem(at: url, to: self.gamesDir)
                    let first = try? Folder(path: self.gamesDir.path).files.first
                    let path = first?.path
                    let fileURL = URL(fileURLWithPath: path!)
                    
                    let data = try? first?.read()
                    let crc = data?.crc32().bytes.toHexString()
                    let sha1 = data?.sha1().bytes.toHexString()
                    let md5 = data?.md5().bytes.toHexString()
                    let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                    fetchRequest.predicate = NSPredicate(format: "crc CONTAINS[cd] %@ OR sha1 CONTAINS[cd] %@ OR md5 CONTAINS[cd] %@", crc ?? "", sha1 ?? "", md5 ?? "")
                    let objects = try! self.parent.context.fetch(fetchRequest)
                    guard let game = objects.first else {
                        print("no match")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let rom = ROMEntity(context: self.parent.context)
                        
                        rom.id = UUID()
                        rom.fileURL = fileURL
                        rom.game = game
                        
                        game.rom = rom
                        try? self.parent.context.save()
                        ActionCreator().downloadComplete(game)
                    }
                }
                
                webView.stopLoading()
            } else {
                print(navigationResponse.response.mimeType)
            }
            
            decisionHandler(.allow)
        }
    }
}
