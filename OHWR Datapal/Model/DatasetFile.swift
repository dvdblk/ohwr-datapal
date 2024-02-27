//
//  DatasetFile.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import SwiftUI
import UniformTypeIdentifiers


fileprivate struct QuickDrawNDJSONObject: Codable {
    /// - Note: Google is using a 64bit integer for `key_id`. UUID is 128bit, thus uuidString is used here.
    let key_id: String
    let word: String
    /// Always CH on output
    let countrycode: String
    let timestamp: Double
    /// - Note: Always `true` while exporting.
    let recognized: Bool
    let drawing: [[[Double]]]
    
    static let defaultCountryCode = "CH"
}

fileprivate struct OutputFile: Encodable {
        
    /// Version of the dataset format
    let formatVersion: String = "1.0"
    /// Width or height of the canvas the strokes are scaled for
    let imageWidthHeight: Double
    /// Format e.g. quickdraw
    let datasetFormat: String
    /// The stroke objects
    let data: [QuickDrawNDJSONObject]
}

/// Represents a Google QuickDraw NDJSON file.
/// https://github.com/googlecreativelab/quickdraw-dataset#the-raw-moderated-dataset
struct DatasetFileNDJSON: FileDocument {
    static var readableContentTypes = [UTType.json]
    
    var dataset: Dataset
    
    static func datasetDataFrom(data: Data) -> Dataset.DataType? {
        guard let jsonData = try? JSONDecoder().decode([QuickDrawNDJSONObject].self, from: data) else { return nil }
        var datasetData: Dataset.DataType = [:]
        var maxPointLocationValue: CGFloat = 0
        for row in jsonData {
            var strokes = [Stroke]()
            for stroke in row.drawing {
                var points = [StrokePoint]()
                for (i, x) in stroke[0].enumerated() {
                    let cgX = CGFloat(x)
                    let y = CGFloat(stroke[1][i])
                    let t = TimeInterval(stroke[2][i])
                    if cgX > maxPointLocationValue {
                        maxPointLocationValue = cgX
                    }
                    if y > maxPointLocationValue {
                        maxPointLocationValue = y
                    }
                    points.append(
                        StrokePoint(location: CGPoint(x: cgX, y: y), timeOffset: t / 1000)
                    )
                }
                strokes.append(Stroke(points: points))
            }
            let closestSquareWidth = ceil(maxPointLocationValue / 128) * 128
            let newDrawing = Drawing(strokes: strokes, canvasSize: CGSize(width: closestSquareWidth, height: closestSquareWidth))
            if var existingLabelData = datasetData[row.word] {
                existingLabelData.append(newDrawing)
            } else {
                datasetData[row.word] = [newDrawing]
            }
        }
        
        return datasetData
    }
    
    static func loadDatasetDataFromLocalFile(result: Result<[URL], Error>) -> Dataset.DataType? {
        do {
            guard
                let selectedFileURL = try? result.get().first,
                selectedFileURL.startAccessingSecurityScopedResource()
            else { return nil }
            let data = try Data(contentsOf: selectedFileURL)
            guard let datasetData = DatasetFileNDJSON.datasetDataFrom(data: data) else { return nil }
            selectedFileURL.stopAccessingSecurityScopedResource()
            return datasetData
        } catch {
            print(error)
        }
        return nil
    }
    
    init(dataset: Dataset) {
        self.dataset = dataset
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let datasetData = DatasetFileNDJSON.datasetDataFrom(data: data) else {
            throw CocoaError(.fileReadCorruptFile)
        }
       
        // FIXME: 64 to selectable size
        self.dataset = Dataset(name: configuration.file.filename ?? UUID().uuidString, data: datasetData, outputCanvasSize: 64)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var ndjsonArray = [QuickDrawNDJSONObject]()
        let desiredSize = dataset.outputCanvasSize
        
        for (label, drawings) in dataset.data {
            for drawing in drawings {
                var quickdrawDrawing = [[[Double]]]()
                for stroke in drawing.strokes {
                    var quickdrawStrokeX: [Double] = []
                    var quickdrawStrokeY: [Double] = []
                    var quickdrawStrokeT: [Double] = []
            
                    for point in stroke.points {
                        // scale with a simple linear transform
                        let x = (point.location.x / drawing.canvasSize.width) * desiredSize
                        let y = (point.location.y / drawing.canvasSize.height) * desiredSize
                        
                        quickdrawStrokeX.append(x)
                        quickdrawStrokeY.append(y)
                        
                        // the time offset of QuickDraw is in milliseconds
                        quickdrawStrokeT.append(point.timeOffset * 1000)
                    }
                    
                    if !quickdrawStrokeX.isEmpty {
                        // Append stroke
                        quickdrawDrawing.append(
                            [quickdrawStrokeX, quickdrawStrokeY, quickdrawStrokeT]
                        )
                    }
                }
                
                ndjsonArray.append(
                    QuickDrawNDJSONObject(
                        key_id: drawing.id.uuidString,
                        word: label,
                        countrycode: QuickDrawNDJSONObject.defaultCountryCode,
                        timestamp: drawing.createdAt.timeIntervalSince1970,
                        // Assume all drawings made in the app are recognized.
                        recognized: true,
                        drawing: quickdrawDrawing
                    )
                )
            }
        }
        let outputFile = OutputFile(imageWidthHeight: dataset.outputCanvasSize, datasetFormat: DatasetFileFormat.quickDraw.rawValue, data: ndjsonArray)
        let data = try JSONEncoder().encode(outputFile)
        return FileWrapper(regularFileWithContents: data)
    }
}
