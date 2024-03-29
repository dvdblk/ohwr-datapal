//
//  SampleCreationView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI
import PencilKit

struct SampleCreationView: View {
    @Environment(\.undoManager) var undoManager
    @Environment(\.colorScheme) var colorScheme
    
    private static let defaultCanvasHeight = 0.7

    let label: String
    @Binding var dataset: Dataset
    @Binding var splitViewColumnVisibility: NavigationSplitViewVisibility
    /// The current strokes finished on the canvas view
    @State private var strokes = [PKStroke]()
    /// Whether to show the list of previous samples
    @State private var showsExistingSamples = true
    /// Limit the sample creation drawing to one stroke
    @State private var limitToOneStroke = false
    @State private var drawWithTouch = !UIDevice.isPad
    @State private var canvasSize = CanvasSize.large
    @StateObject private var undoRedoObserver = UndoRedoObserver()
    
    @State private var canvasCGSize: CGSize = .zero
    
    private let canvasBridge = PKCanvasBridge()
    private let drawingManager = DrawingManager.shared
    
    @ViewBuilder
    var sampleDrawingView: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer().layoutPriority(1)
            PKCanvasRepresentation(
                canvasBridge: canvasBridge,
                canUndo: $undoRedoObserver.canUndo,
                canRedo: $undoRedoObserver.canRedo,
                drawWithTouch: $drawWithTouch,
                limitToOneStroke: $limitToOneStroke,
                strokes: $strokes
            )
            .saveSize(in: $canvasCGSize)
            .frame(maxWidth: canvasSize.exactPxSize, maxHeight: canvasSize.exactPxSize)
            .cornerRadius(8)
            .defaultShadow()
            .aspectRatio(1, contentMode: .fit)
            .layoutPriority(10)
            HStack {
                Button {
                    saveDrawing()
                } label: {
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1, contentMode: .fit)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(strokes.count <= 0)
                // Undo redo
                VStack(spacing: 4) {
                    HStack {
                        Button {
                            undoManager?.undo()
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .buttonStyle(.bordered)
                        .disabled(!undoRedoObserver.canUndo)
                        Button {
                            undoManager?.redo()
                        } label: {
                            Image(systemName: "arrow.uturn.forward")
                        }
                        .buttonStyle(.bordered)
                        .disabled(!undoRedoObserver.canRedo)
                    }
                    Text("\(strokes.count) stroke\(strokes.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Divider()
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                Button {
                    clearDrawing()
                } label: {
                    Image(systemName: "trash")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .layoutPriority(2)
                .aspectRatio(1, contentMode: .fit)
                .buttonStyle(.borderedProminent)
                .tint(.pink.opacity(0.8))
                .disabled(strokes.count <= 0)
            }
            .font(.headline)
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemBackground))
            )
            .compositingGroup()
            .defaultShadow()
            .offset(y: 16)
            Spacer().layoutPriority(1)
        }
        .padding(.bottom, 8)
        .padding(.top, 8)
    }
    
    @ViewBuilder
    var existingSamplesView: some View {
        Group {
            if let samples = dataset.data[label], !samples.isEmpty {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 64, maximum: 128))],
                        spacing: 8
                    ) {
                        ForEach(samples.reversed()) { sample in
                            DrawingPreviewRow(drawing: sample)
                                .frame(width: 64, height: 64)
                                .contextMenu {
                                    Button(role: .destructive, action: {
                                        if let sampleIndexToRemove = samples.firstIndex(of: sample) {
                                            dataset.data[label]?.remove(at: sampleIndexToRemove)
                                        }
                                    }, label: {
                                        Label("Delete", systemImage: "trash")
                                    })
                                }
                            }
                    }.padding()
                }
            } else {
                Text("Add samples for this label by drawing")
            }
        }
    }
        
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                sampleDrawingView
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geometry.size.height * (showsExistingSamples ? Self.defaultCanvasHeight : 1))
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
                if showsExistingSamples {
                    Divider()
                    existingSamplesView
                        .frame(height: geometry.size.height * (1 - Self.defaultCanvasHeight))
                }
            }
            .frame(maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if UIDevice.isPad {
                    ColumnVisibilityBarButton(
                        splitViewColumnVisibility: $splitViewColumnVisibility
                    )
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(label).font(.headline)
                        if splitViewColumnVisibility == .detailOnly, let sampleCount = dataset.data[label]?.count {
                            Text("\(sampleCount) sample\(sampleCount != 1 ? "s" : "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    Toggle(isOn: $showsExistingSamples.animation(.spring())) {
                        Label("Show existing samples", systemImage: "rectangle.grid.1x2")
                    }
                    Toggle(isOn: $limitToOneStroke) {
                        Label("One stroke limit", systemImage: "1.square")
                    }
                        .onChange(of: limitToOneStroke) { _ in
                            if strokes.count > 1 {
                                clearDrawing()
                            }
                        }
                    Toggle(isOn: $drawWithTouch) {
                        Label("Draw with Touch", systemImage: "hand.draw")
                    }

                    
                    Menu {
                        Picker(selection: $canvasSize.animation()) {
                            ForEach(CanvasSize.allCases) { size in
                                Text(size.description).tag(size)
                            }
                        } label: {
                            Label("Canvas size", systemImage: "square.and.pencil")
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Label("Canvas size", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            undoRedoObserver.undoManager = undoManager
        }
        .onChange(of: undoManager) { newManager in
            // UndoManager can change during the lifecycle so we need to keep it updated in the observer
            undoRedoObserver.undoManager = newManager
        }
        .onChange(of: canvasCGSize) { _ in
            clearDrawing()
        }
    }
    
    func clearDrawing() {
        canvasBridge.clearDrawing?()
    }
    
    func saveDrawing() {
        let drawing = Drawing(strokes: strokes, canvasSize: canvasCGSize)
        dataset.data[label]?.append(drawing)
        clearDrawing()
    }
}

struct SampleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                SampleCreationView(label: "square", dataset: .constant(Dataset.sampleData[0]), splitViewColumnVisibility: .constant(.automatic))
            }
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Landscape")
            .previewInterfaceOrientation(.landscapeLeft)
            NavigationStack {
                SampleCreationView(label: "square", dataset: .constant(Dataset.sampleData[0]), splitViewColumnVisibility: .constant(.automatic))
            }
            .previewDisplayName("iPhone")
        }
    }
}
