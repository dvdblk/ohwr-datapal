//
//  DatasetFile.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import SwiftUI
import UniformTypeIdentifiers

/// Represents a Google QuickDraw NDJSON file.
/// https://github.com/googlecreativelab/quickdraw-dataset#the-raw-moderated-dataset
struct DatasetFileNDJSON: FileDocument {
    static var readableContentTypes = [UTType.json]

    var dataset: Dataset
    
    private struct QuickDrawNDJSONObject: Codable {
        /// - Note: Google is using a 64bit integer for `key_id`. UUID is 128bit, thus uuidString is used here.
        let key_id: String
        let word: String
        /// Always CH on output
        let countrycode: String
        let timestamp: Date
        /// - Note: Always `true` while exporting.
        let recognized: Bool
        let drawing: [[[Int]]]
        
        static let defaultCountryCode = "CH"
    }
    
    
    init(dataset: Dataset) {
        self.dataset = dataset
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        // TODO: importing
        dataset = Dataset(name: configuration.file.filename ?? UUID().uuidString, data: [:])
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var ndjsonArray = [QuickDrawNDJSONObject]()
        for (label, drawings) in dataset.data {
            for drawing in drawings {
                var quickdrawDrawing = [[[Int]]]()
                for stroke in drawing.strokes {
                    var quickdrawStrokeX: [Int] = []
                    var quickdrawStrokeY: [Int] = []
                    var quickdrawStrokeT: [Int] = []
                    
                    for point in stroke.points {
                        quickdrawStrokeX.append(Int(point.location.x))
                        quickdrawStrokeY.append(Int(point.location.y))
                        // FIXME: timeOffset is in seconds but should be milliseconds
                        quickdrawStrokeT.append(Int(point.timeOffset))
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
                        timestamp: drawing.createdAt,
                        // Assume all drawings made in the app are recognized.
                        recognized: true,
                        drawing: quickdrawDrawing
                    )
                )
            }
        }

        let data = try JSONEncoder().encode(ndjsonArray)
        return FileWrapper(regularFileWithContents: data)
    }
}
