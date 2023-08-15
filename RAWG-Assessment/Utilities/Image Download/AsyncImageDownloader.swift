//
//  AsyncImageDownloader.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class AsyncImageDownloader {
    private let serialAccessQueue = OperationQueue()
    private let imageDownloadingQueue = OperationQueue()
    private var completionHandlers = [UUID: [(UIImage?) -> Void]]()
    private var cache = NSCache<NSUUID, UIImage>()
    
    init() {
        serialAccessQueue.maxConcurrentOperationCount = 1
    }
    
    func downloadAsync(_ identifier: UUID, imageURLString: String, completion: ((UIImage?)-> Void)? = nil) {
        serialAccessQueue.addOperation {
            if let completion {
                let handlers = self.completionHandlers[identifier, default: []]
                self.completionHandlers[identifier] = handlers + [completion]
            }
            
            self.downloadImage(for: identifier, imageURLString: imageURLString)
        }
    }
    
    private func downloadImage(for identifier: UUID, imageURLString: String) {
        guard operation(for: identifier) == nil else { return }
        
        if let image = downloadedImage(for: identifier) {
            invokeCompletionHandlers(for: identifier, with: image)
            return
        }
        
        let downloadOperation = ImageDownloadOperation(identifier: identifier, imageURLString: imageURLString)
        downloadOperation.completionBlock = { [weak downloadOperation] in
            guard let downloadedImage = downloadOperation?.downloadedImage else { return }
            self.cache.setObject(downloadedImage, forKey: identifier as NSUUID)
            
            self.serialAccessQueue.addOperation {
                self.invokeCompletionHandlers(for: identifier, with: downloadedImage)
            }
        }
        
        imageDownloadingQueue.addOperation(downloadOperation)
    }
    
    func downloadedImage(for identifier: UUID) -> UIImage? {
        cache.object(forKey: identifier as NSUUID)
    }
    
    func cancelDownload(_ identifier: UUID) {
        serialAccessQueue.addOperation {
            self.imageDownloadingQueue.isSuspended = true
            self.operation(for: identifier)?.cancel()
            self.completionHandlers[identifier] = nil
            self.imageDownloadingQueue.isSuspended = false
        }
    }
    
    private func operation(for identifier: UUID) -> ImageDownloadOperation? {
        for case let downloadOperation as ImageDownloadOperation in imageDownloadingQueue.operations where !downloadOperation.isCancelled && downloadOperation.identifier == identifier {
            return downloadOperation
        }
        
        return nil
    }
    
    private func invokeCompletionHandlers(for identifier: UUID, with downloadedImage: UIImage) {
        let completionHandlers = self.completionHandlers[identifier, default: []]
        self.completionHandlers[identifier] = nil
        
        for completionHandler in completionHandlers {
            completionHandler(downloadedImage)
        }
    }
}

