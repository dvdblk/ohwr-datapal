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
    /// The final size of the canvas. Every stroke will be scaled down to fit from the original input (e.g. 512x512) to this value.
    var outputCanvasSize: CGSize = CGSize(width: 64, height: 64)
        
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
            "square": [Drawing(strokes: [Stroke()], canvasSize: .zero)],
            "triangle": [Drawing(strokes: [Stroke()], canvasSize: .zero)]
        ]),
        Dataset(name: "Empty dataset", data: [:])
    ]
}
