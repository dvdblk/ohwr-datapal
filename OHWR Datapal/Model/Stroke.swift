//
//  Stroke.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import Foundation
import PencilKit

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
    
    init(points: [StrokePoint] = []) {
        self.points = points
    }
    
    init(pkStroke: PKStroke) {
        var points = [StrokePoint]()
        for point in pkStroke.path {
            points.append(
                StrokePoint(
                    location: point.location,
                    timeOffset: point.timeOffset,
                    opacity: point.opacity,
                    force: point.force,
                    azimuth: point.azimuth,
                    altitude: point.altitude
                )
            )
        }
        self.init(points: points)
    }
}
