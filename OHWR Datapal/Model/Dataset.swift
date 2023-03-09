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
    let id = UUID()
    /// Name of the dataset
    var name: String
    /// Dictionary of label: [stroke]
    var data: [String: [Stroke]]
    /// Date of creation
    let createdAt = Date()
    /// The final size of the canvas. Every stroke will be scaled down to fit from the original input (e.g. 512x512) to this value.
    let canvasSize: CGSize = CGSize(width: 64, height: 64)
        
    var labels: [String] { Array(data.keys) }
    
    struct Data {
        var name: String = ""
        var data: [String: [Stroke]] = [:]
        
        var isValidName: Bool {
            return
                name.count < 64 &&
                !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

extension Dataset {
    static let sampleData: [Dataset] = [
        Dataset(name: "Squares and triangles", data: ["square": [Stroke(points: [])], "triangle": [Stroke(points: [])]]),
        Dataset(name: "Empty dataset", data: [:])
    ]
}
