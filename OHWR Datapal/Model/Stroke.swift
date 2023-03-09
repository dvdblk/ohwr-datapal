//
//  Stroke.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
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
