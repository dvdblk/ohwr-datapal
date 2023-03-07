//
//  Dataset.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import Foundation
import PencilKit

/// Represent a non-generic dataset of strokes and labels.
/// Multi-stroke
struct Dataset: Identifiable {
    let id = UUID()
    /// Name of the dataset
    let name: String
    /// Dictionary of label: [stroke]
    var data: [String: [PKStroke]]
    
    var labels: [String] { Array(data.keys) }
    
    struct Data {
        var name: String = "New dataset"
        var data: [String: [PKStroke]] = [:]
    }
}

extension Dataset {
    private static let ink = PKInk(.pen, color: PKInkingTool.convertColor(.white, from: .light, to: .dark))
    
    static let sampleData: [Dataset] = [
        Dataset(name: "Squares and triangles", data: ["square": [PKStroke(ink: ink, path: PKStrokePath())], "triangle": [PKStroke(ink: ink, path: PKStrokePath())]]),
        Dataset(name: "Empty dataset", data: [:])
    ]
}

extension Dataset: Equatable, Hashable {
    static func == (lhs: Dataset, rhs: Dataset) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
