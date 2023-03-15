//
//  DrawingManager.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import UIKit

final class DrawingManager {
    
    static let shared = DrawingManager()
    private let cache = DrawingImageCache()
    
    private init() { }
    
    private var defaultImage: CGImage? = nil
    
    func getCGImage(drawing: Drawing) -> CGImage {
        if let existingCGImage = cache.get(with: drawing.id.uuidString) {
            return existingCGImage
        } else {
            guard let drawingCGImage = drawing.rasterized() else {
                if let defaultImage = defaultImage {
                    return defaultImage
                } else {
                    let defaultImage = createDefaultImage()
                    self.defaultImage = defaultImage
                    return defaultImage
                }
            }
            cache.set(image: drawingCGImage, key: drawing.id.uuidString)
            return drawingCGImage
        }
    }
    
    private func createDefaultImage() -> CGImage {
        let bounds = CGRect(x: 0, y: 0, width: 64, height: 64)
        let bitmapContext = CGContext(
            data: nil,
            width: 64,
            height: 64,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        let cgContext = bitmapContext!
        cgContext.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1))
        cgContext.fill([bounds])
        return cgContext.makeImage()!
    }
}
