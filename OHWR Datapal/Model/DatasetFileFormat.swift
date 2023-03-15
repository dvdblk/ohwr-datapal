//
//  DatasetFileFormat.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import Foundation

enum DatasetFileFormat: String, CaseIterable, Identifiable {
    /// Default json format
    case quickDraw = "QuickDraw"
    
    var id: DatasetFileFormat { self }
}
