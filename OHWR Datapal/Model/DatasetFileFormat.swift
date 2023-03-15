//
//  DatasetFileFormat.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import Foundation

enum DatasetFileFormat: String, CaseIterable, Identifiable {
    /// Default json format
    case ndjson = "NDJSON"
    
    var id: DatasetFileFormat { self }
}
