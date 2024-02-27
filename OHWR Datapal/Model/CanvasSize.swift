//
//  CanvasSize.swift
//  OHWR Datapal
//
//  Created by David Bielik on 12/03/2023.
//

import Foundation

enum CanvasSize: CaseIterable, Identifiable, CustomStringConvertible {
    case small
    case medium
    case large
    case fill
    
    static var defaultSize: CanvasSize { return .large }
    
    var description: String {
        switch self {
        case .small: return "64x64"
        case .medium: return "128x128"
        case .large: return "256x256"
        case .fill: return "Fill screen size"
        }
    }
    
    var exactPxSize: Double {
        switch self {
        case .small: return 64
        case .medium: return 128
        case .large: return 256
        case .fill: return .infinity
        }
    }
    
    var id: CanvasSize { self }
}
