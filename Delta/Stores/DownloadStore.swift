import SwiftUI

class DownloadTask: ObservableObject {
    var task: URLSessionDownloadTask
    var progress: DownloadStore.DownloadProgressBlock
    var completion: DownloadStore.DownloadCompletionBlock
    
    @Published var progressValue: CGFloat = 0.0
    
    init(task: URLSessionDownloadTask, progress: @escaping DownloadStore.DownloadProgressBlock, completion: @escaping DownloadStore.DownloadCompletionBlock) {
        self.task = task
        self.progress = progress
        self.completion = completion
    }
}

class DownloadStore: NSObject {
    static let shared = DownloadStore()
    
    public typealias DownloadCompletionBlock = (_ error : Error?, _ fileUrl:URL?) -> Void
    public typealias DownloadProgressBlock = (_ progress : CGFloat) -> Void
    
    private var session: URLSession!
    @Published var ongoingDownloads: [URL: DownloadTask] = [:]
    
    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func download(url: URL, progress: @escaping DownloadProgressBlock, completion: @escaping DownloadCompletionBlock) -> DownloadTask? {
        guard ongoingDownloads[url] == nil else {return nil}
        let task = self.session.downloadTask(with: url)
        let downloadTask = DownloadTask(task: task, progress: progress, completion: completion)
        ongoingDownloads[url] = downloadTask
        task.resume()
        return downloadTask
    }
}

extension DownloadStore: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
            print("no match")
            return
        }
        
        let task = ongoingDownloads[url]
        task?.progressValue = 1.0
        task?.completion(nil, location)
        ongoingDownloads.removeValue(forKey: url)
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else {
            return
        }
        
        if  let task = self.ongoingDownloads[downloadTask.originalRequest!.url!] {
            let progressValue: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
            task.progressValue = progressValue
            task.progress(progressValue)
        }
    }
}
