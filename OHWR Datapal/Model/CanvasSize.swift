//
//  CanvasSize.swift
//  OHWR Datapal
//
//  Created by David Bielik on 12/03/2023.
//

import Foundation

enum CanvasSize: Double, CaseIterable, Identifiable, CustomStringConvertible {
    case small = 0.6
    case medium = 0.8
    case fill = 1
    
    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .fill: return "Fill screen size"
        }
    }
    
    var id: CanvasSize { self }
}
