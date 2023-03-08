//
//  Dataset.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import Foundation
import PencilKit

struct StrokePoint: Hashable {
    let location: CGPoint
    let timeOffset: TimeInterval
    //let size: CGSize
    let opacity: CGFloat
    let force: CGFloat
    let azimuth: CGFloat
    let altitude: CGFloat
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

struct Stroke: Hashable {
    var points: [StrokePoint]
    
    var path: PKStrokePath {
        let pkStrokePoints = points.map {
            PKStrokePoint(
                location: $0.location,
                timeOffset: $0.timeOffset,
                size: .zero,
                opacity: $0.opacity,
                force: $0.force,
                azimuth: $0.azimuth,
                altitude: $0.altitude
            )
        }
        return PKStrokePath(controlPoints: pkStrokePoints, creationDate: Date())
    }
}

/// Represent a non-generic dataset of strokes and labels.
/// Multi-stroke
struct Dataset: Identifiable {
    let id = UUID()
    /// Name of the dataset
    let name: String
    /// Dictionary of label: [stroke]
    var data: [String: [Stroke]]
        
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
