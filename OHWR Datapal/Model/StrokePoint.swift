//
//  StrokePoint.swift
//  OHWR Datapal
//
//  Created by David Bielik on 11/03/2023.
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
    
    init(location: CGPoint, timeOffset: TimeInterval = 0, opacity: CGFloat = 1, force: CGFloat = 1, azimuth: CGFloat = 1, altitude: CGFloat = 1) {
        self.location = location
        self.timeOffset = timeOffset
        self.opacity = opacity
        self.force = force
        self.azimuth = azimuth
        self.altitude = altitude
    }
}
