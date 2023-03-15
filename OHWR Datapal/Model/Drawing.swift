//
//  Drawing.swift
//  OHWR Datapal
//
//  Created by David Bielik on 11/03/2023.
//

import Foundation
import PencilKit

/// Contains the strokes and canvas size information
struct Drawing: Hashable, Identifiable {
    let id = UUID()
    let strokes: [Stroke]
    /// The size of the canvas where this drawing was made
    let canvasSize: CGSize
    
    init(strokes: [Stroke], canvasSize: CGSize = .zero) {
        self.strokes = strokes
        self.canvasSize = canvasSize
    }
    
    init(strokes: [PKStroke], canvasSize: CGSize = .zero) {
        self.init(
            strokes: strokes.map({ Stroke(pkStroke: $0)}),
            canvasSize: canvasSize
        )
    }
    
    // MARK: - Rasterization
    func rasterized() -> CGImage? {
        let grayscale = CGColorSpaceCreateDeviceGray()
        let intermediate_bitmap_context = CGContext(
            data: nil,
            width: Int(canvasSize.width),
            height: Int(canvasSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        )
        intermediate_bitmap_context?.setStrokeColor(
            red: 1, green: 1, blue: 1, alpha: 1.0
        )
        // Rotate + translate to avoid a flipped image due to CGImage shenanigans
        let transform = CGAffineTransform
            .init(rotationAngle: 180 / 180 * .pi)
            .translatedBy(x: -canvasSize.width, y: -canvasSize.height)
        let path = CGMutablePath()
        for strokeIndex in 0..<strokes.count {
            let stroke = strokes[strokeIndex]
            guard let startPoint = stroke.points.first else { break }
            path.move(to: startPoint.location, transform: transform)
            for point in stroke.points.dropFirst() {
                path.addLine(to: point.location, transform: transform)
            }
        }
        intermediate_bitmap_context?.setLineWidth(15)
        intermediate_bitmap_context?.beginPath()
        intermediate_bitmap_context?.addPath(path)
        intermediate_bitmap_context?.strokePath()
        guard let intermediate_image = intermediate_bitmap_context?.makeImage() else { return nil }

        let final_bitmap_context = CGContext(
            data:nil, width:64, height:64, bitsPerComponent:8, bytesPerRow:0,
            space:grayscale, bitmapInfo:CGImageAlphaInfo.none.rawValue)
        let final_rect = CGRect(x: 0.0, y: 0.0, width: 64, height: 64)
        final_bitmap_context?.draw(intermediate_image, in: final_rect)
        return final_bitmap_context?.makeImage()
    }
}
