//
//  SamplePreviewRow.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import SwiftUI
import PencilKit

struct DrawingPreviewRow: View {
    
    let drawing: Drawing
    
    @State private var image: Image?
    
    var body: some View {
        ZStack {
            image?
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1, antialiased: true)
                )
        }
        .onAppear(perform: loadImage)
        
    }
    
    func loadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let cgImage = DrawingManager.shared.getCGImage(drawing: drawing)
            DispatchQueue.main.async {
                image = Image(uiImage: UIImage(cgImage: cgImage).withHorizontallyFlippedOrientation())
            }
        }
    }
}

struct DrawingPreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        DrawingPreviewRow(drawing: Drawing.init(strokes: [Stroke()]))
    }
}
