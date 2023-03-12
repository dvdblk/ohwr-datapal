//
//  SquiggleShape.swift
//  OHWR Datapal
//
//  Created by David Bielik on 12/03/2023.
//

import SwiftUI

struct SquiggleShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height

        return Path { path in
            path.move(to: CGPoint(x: width*0.15, y: height*0.28))
            path.addQuadCurve(to: CGPoint(x: width*0.4, y: height*0.6), control: CGPoint(x: width*0.3, y: height*0.1))
            path.addQuadCurve(to: CGPoint(x: width*0.56, y: height*0.5), control: CGPoint(x: width*0.46, y: height*0.9))
            path.addQuadCurve(to: CGPoint(x: width*0.64, y: height*0.44), control: CGPoint(x: width*0.62, y: height*0.3))
            path.addQuadCurve(to: CGPoint(x: width*0.88, y: height*0.52), control: CGPoint(x: width*0.72, y: height*0.8))
        }
    }
}

struct SquiggleShape_Previews: PreviewProvider {
    static var previews: some View {
        SquiggleShape()
            .stroke(style: StrokeStyle(lineCap: .round))
            .stroke(.tint, lineWidth: 4)

    }
}
