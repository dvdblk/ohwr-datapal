//
//  Dataset.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import Foundation

enum AllowedOutputSizes: Int, CaseIterable, Identifiable {
    case small = 64
    case medium = 128
    case large = 256
    
    var id: AllowedOutputSizes {
        return self
    }
}

/// Represent a non-generic dataset of strokes and labels.
/// Multi-stroke
struct Dataset: Identifiable {
    /// For each label store a list of drawings (samples)
    typealias DataType = [String: [Drawing]]
    
    let id = UUID()
    /// Name of the dataset
    var name: String
    /// Dictionary of label: [stroke]
    var data: DataType
    /// Date of creation
    let createdAt = Date()
    /// The final width and height of the samples (downscaled or upscaled from original canvas size)
    let outputCanvasSize: Double
        
    var labels: [String] { Array(data.keys) }
    
    struct Data {
        var name: String = ""
        var data: DataType = [:]
        var outputSize: Double = 256
        
        var isValidName: Bool {
            return
                name.count < 64 &&
                !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

extension Dataset {
    static let sampleData: [Dataset] = [
        Dataset(name: "Squares and triangles", data: [
            "square": [
                Drawing(strokes: [
                    Stroke(points: [
                        StrokePoint(location: CGPoint(x: 64, y: 64)),
                        StrokePoint(location: CGPoint(x: 64, y: 192)),
                        StrokePoint(location: CGPoint(x: 192, y: 192)),
                        StrokePoint(location: CGPoint(x: 192, y: 64)),
                        StrokePoint(location: CGPoint(x: 64, y: 64))
                    ])
                ], canvasSize: CGSize(width: 256, height: 256))
            ],
            "triangle": [
                Drawing(strokes: [
                    Stroke(points: [
                        StrokePoint(location: CGPoint(x: 128, y: 64)),
                        StrokePoint(location: CGPoint(x: 64, y: 192)),
                        StrokePoint(location: CGPoint(x: 192, y: 192)),
                        StrokePoint(location: CGPoint(x: 128, y: 64)),
                    ])
                ], canvasSize: CGSize(width: 256, height: 256))
            ]
        ], outputCanvasSize: 256),
        Dataset(name: "Empty dataset", data: [:], outputCanvasSize: 64)
    ]
}
