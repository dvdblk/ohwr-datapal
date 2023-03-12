//
//  PKCanvasRepresentation.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import SwiftUI
import PencilKit


/// Bridge class that contains closures (with UIKit calls) which are called from SwiftUI
class PKCanvasBridge {
    var clearDrawing: (() -> Void)?
}

struct PKCanvasRepresentation: UIViewRepresentable {
    
    @Binding var canUndo: Bool
    @Binding var canRedo: Bool
    /// Whether to allow drawing with touch
    @Binding var drawWithTouch: Bool
    /// Whether to prevent drawing after one stroke
    @Binding var limitToOneStroke: Bool
    /// The currently drawn strokes on the canvas
    @Binding var strokes: [PKStroke]
    
    var canvasBridge: PKCanvasBridge
    
    init(canvasBridge: PKCanvasBridge, canUndo: Binding<Bool>, canRedo: Binding<Bool>, drawWithTouch: Binding<Bool>, limitToOneStroke: Binding<Bool>, strokes: Binding<[PKStroke]>) {
        self.canvasBridge = canvasBridge
        self._canUndo = canUndo
        self._canRedo = canRedo
        self._drawWithTouch = drawWithTouch
        self._limitToOneStroke = limitToOneStroke
        self._strokes = strokes
    }
    
    var defaultInkingTool: PKInkingTool {
        PKInkingTool(
            .pen,
            color: PKInkingTool.convertColor(.white, from: .light, to: .dark), width: 10
        )
    }
    
    private func updateUndoRedo(undoManager: UndoManager?, strokes: [PKStroke]) {
        if let undoManager = undoManager {
            canUndo = undoManager.canUndo && !strokes.isEmpty
            canRedo = undoManager.canRedo
        }
    }
    
    private func clearDrawing(canvasView: PKCanvasView) {
        canvasView.drawing = PKDrawing()
        canvasView.undoManager?.removeAllActions()
        updateUndoRedo(undoManager: canvasView.undoManager, strokes: canvasView.drawing.strokes)
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = drawWithTouch ? .anyInput : .pencilOnly
        canvasView.delegate = context.coordinator
        canvasView.tool = defaultInkingTool
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawingPolicy = drawWithTouch ? .anyInput : .pencilOnly
        canvasBridge.clearDrawing = {
            clearDrawing(canvasView: uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PKCanvasRepresentation

        init(_ parent: PKCanvasRepresentation) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let strokes = canvasView.drawing.strokes

            if parent.limitToOneStroke && strokes.count > 1, let firstStroke = strokes.first {
                canvasView.drawing = PKDrawing()
                if let undoManager = canvasView.undoManager {
                    // Workaround for undo being broken after inserting a stroke manually
                    // https://developer.apple.com/forums/thread/651788
                    undoManager.groupsByEvent = false
                    canvasView.drawing.strokes.append(firstStroke)
                    undoManager.beginUndoGrouping()
                    undoManager.registerUndo(withTarget: canvasView, handler: { [weak self] canvas in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            //self?.parent.clearDrawing(canvasView: canvasView)
                            canvas.drawing.strokes.removeLast()
                        }
                    })
                    undoManager.endUndoGrouping()
                    undoManager.groupsByEvent = true
                }
                
                // Animate blink of the canvas on attempted multi stroke
                UIView.animate(withDuration: 0.26, delay: 0, options: [.curveEaseInOut], animations: {
                    canvasView.backgroundColor = .systemRed.withAlphaComponent(0.18)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                        canvasView.backgroundColor = .systemBackground
                    })
                })
            }
            
            // Update undo / redo buttons after every drawing change
            parent.updateUndoRedo(undoManager: canvasView.undoManager, strokes: strokes)
            // Update the number of strokes
            parent.strokes = canvasView.drawing.strokes
        }
    }
}

