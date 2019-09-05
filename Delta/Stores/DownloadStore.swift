import SwiftUI

class DownloadTask: ObservableObject {
  var task: URLSessionDownloadTask
  var id: UUID
  
  @Published var progress = 0.0
  
  init(task: URLSessionDownloadTask, id: UUID) {
    self.task = task
    self.id = id
  }
}

class DownloadStore: NSObject {
  static let shared = DownloadStore()
  
  public typealias DownloadCompletionBlock = (_ error : Error?, _ fileUrl:URL?) -> Void
  public typealias DownloadProgressBlock = (_ progress : CGFloat) -> Void
  
  private var session = URLSession.shared
  @Published var ongoingDownloads: [URL: DownloadTask] = [:]

  func download(url: URL, id: UUID) {
    guard ongoingDownloads[url] == nil else {return}
    
    let task = self.session.downloadTask(with: url)
    ongoingDownloads[url] = DownloadTask(task: task, id: id)
    task.resume()
  }
}

extension DownloadStore: URLSessionDelegate, URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    guard let url = downloadTask.originalRequest?.url, ongoingDownloads[url] == nil else {
      return
    }
    
    // inform the download task
  }
}
