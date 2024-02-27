//
//  NewDatasetContext.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

class NewDatasetContext: ObservableObject {
    @Published var isValidName: Bool = false
    @Published var datasetData = Dataset.Data() {
        didSet { validateFields() }
    }
    
    var dataset: Dataset {
        return Dataset(name: datasetData.name, data: datasetData.data, outputCanvasSize: datasetData.outputSize)
    }
    
    init(data: Dataset.Data = Dataset.Data()) {
        self.datasetData = data
    }
    
    private func validateFields() {
        isValidName = datasetData.isValidName
    }
    
    public func resetDatasetData() {
        self.datasetData = Dataset.Data()
    }
}
