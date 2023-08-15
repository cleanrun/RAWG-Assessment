//
//  UIImage+Extension.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import UIKit

extension UIImage {
    static func downloadImageFromURL(_ url: URL) -> UIImage? {
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
    }
}
