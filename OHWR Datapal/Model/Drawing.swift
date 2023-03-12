//
//  Drawing.swift
//  OHWR Datapal
//
//  Created by David Bielik on 11/03/2023.
//

import Foundation
import PencilKit

/// Contains the strokes and canvas size information
struct Drawing: Hashable {
    let strokes: [Stroke]
    let canvasSize: CGSize
    
    init(strokes: [Stroke], canvasSize: CGSize = .zero) {
        self.strokes = strokes
        self.canvasSize = .zero
    }
    
    init(strokes: [PKStroke], canvasSize: CGSize = .zero) {
        self.init(
            strokes: strokes.map({ Stroke(pkStroke: $0)}),
            canvasSize: canvasSize
        )
    }
}
