//
//  DrawingImageCache.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import UIKit

/// CGImage NSCache wrapper
final class DrawingImageCache {
    
    private lazy var imageCache = NSCache<NSString, NSData>()
    private let lock = NSLock()
    
    @discardableResult
    public func set(image: CGImage, key: String) -> Bool {
        lock.lock(); defer { lock.unlock() }
        
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { return false }
        
        imageCache.setObject(mutableData as NSData, forKey: key as NSString)
        
        return true
    }
    
    public func get(with key: String) -> CGImage? {
        lock.lock(); defer { lock.unlock() }
        
        let width = 64
        let height = 64
        let numComponents = 1
        // Grayscale
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        guard let imageNSData = imageCache.object(forKey: key as NSString) else { return nil }
        let imageData = Data(referencing: imageNSData)
        var dataProvider: CGDataProvider? = nil
        imageData.withUnsafeBytes { dataPtr in
            guard let bytes = dataPtr.bindMemory(to: UInt8.self).baseAddress,
                  let cfData = CFDataCreate(nil, bytes, imageData.count) else { return }
                
            dataProvider = CGDataProvider(data: cfData)
        }
        
        guard let provider = dataProvider else { return nil }
        let imageRef = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8 * numComponents,
            bytesPerRow: width * numComponents,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: 0),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return imageRef
    }
}
