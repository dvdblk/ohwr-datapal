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
}
