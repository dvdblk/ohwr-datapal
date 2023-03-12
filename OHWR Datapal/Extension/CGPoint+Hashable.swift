//
//  CGPoint+Hashable.swift
//  OHWR Datapal
//
//  Created by David Bielik on 11/03/2023.
//

import Foundation

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
