//
//  ImageDownloadOperation.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class ImageDownloadOperation: Operation {
    let identifier: UUID
    let imageURLString: String
    private(set) var downloadedImage: UIImage?
    
    init(identifier: UUID, imageURLString: String) {
        self.identifier = identifier
        self.imageURLString = imageURLString
    }
    
    override func main() {
        guard !isCancelled else { return }
        downloadedImage = downloadImage()
    }
    
    private func downloadImage() -> UIImage? {
        if let url = URL(string: imageURLString) {
            if let data = try? Data(contentsOf: url) {
                //let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
                
                let maxDimensionInPixels = Swift.max(177, 177) * UIScreen.main.scale
                let downsampleOptions = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
                ] as CFDictionary
                
                guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
                
                return UIImage(cgImage: downsampledImage)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

