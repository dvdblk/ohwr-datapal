//
//  Dataset.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import Foundation

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
    /// The final size of the canvas. Every stroke will be scaled down to fit from the original input (e.g. 256x256) to this value.
    var outputCanvasSize: CGSize = CGSize(width: 256, height: 256)
        
    var labels: [String] { Array(data.keys) }
    
    struct Data {
        var name: String = ""
        var data: DataType = [:]
        
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
        ]),
        Dataset(name: "Empty dataset", data: [:])
    ]
}
