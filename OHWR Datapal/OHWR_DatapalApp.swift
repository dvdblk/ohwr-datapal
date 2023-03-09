//
//  OHWR_DatapalApp.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

@main
struct OHWR_DatapalApp: App {
    // MARK: - Data
    /// The array of datasets
    @State private var datasets = Dataset.sampleData
    /// Currently selected dataset
    @State private var selectedDatasetId: UUID? = nil
    /// Currently selected label
    @State private var selectedLabelId: String? = nil
    /// Data for the dataset that should be created
    @StateObject private var newDatasetContext = NewDatasetContext()
    
    @State private var splitViewColumnVisibility: NavigationSplitViewVisibility = .all
    @State private var isPresentingNewDatasetView = false
    
    func datasetIndex(with id: UUID?) -> Int? {
        return datasets.firstIndex(where: { $0.id == id })
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if UIDevice.isPad && datasets.isEmpty {
                    EmptyDatasetsView(isPresentingNewDatasetView: $isPresentingNewDatasetView)
                } else {
                    NavigationSplitView(columnVisibility: $splitViewColumnVisibility) {
                        DatasetListView(
                            datasets: $datasets,
                            selectedDatasetId: $selectedDatasetId,
                            isPresentingNewDatasetView: $isPresentingNewDatasetView
                        )
                    } content: {
                        if let selectedDatasetId = selectedDatasetId, let datasetIndex = datasetIndex(with: selectedDatasetId) {
                            DatasetDetailView(dataset: $datasets[datasetIndex], selectedLabelId: $selectedLabelId)
                        } else {
                            EmptyDatasetContentView()
                        }
                    } detail: {
                        if let selectedDatasetId = selectedDatasetId, let selectedLabelId = selectedLabelId, let datasetIndex = datasetIndex(with: selectedDatasetId) {
                            SampleCreationView(label: selectedLabelId, dataset: $datasets[datasetIndex], splitViewColumnVisibility: $splitViewColumnVisibility)
                        } else {
                            EmptyDatasetDetailView()
                        }
                    }
                    .onAppear {
                        // Select the first dataset if device is iPad and datasets are not empty
                        if UIDevice.isPad, !datasets.isEmpty {
                            withAnimation {
                                selectedDatasetId = datasets[0].id
                            }
                        }
                    }
                }
            }
            .onChange(of: selectedDatasetId) { _ in
                // Deselect detail view when dataset changes
                selectedLabelId = nil
            }
            .onChange(of: selectedLabelId) { _ in
                // Use double column when a label of a dataset is selected
                if selectedLabelId == nil {
                    splitViewColumnVisibility = .all
                } else {
                    splitViewColumnVisibility = .doubleColumn
                }
            }
            .sheet(isPresented: $isPresentingNewDatasetView) {
                NavigationView {
                    NewDatasetView(newDatasetContext: newDatasetContext)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewDatasetView = false
                                    newDatasetContext.resetDatasetData()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newDataset = newDatasetContext.dataset
                                    datasets.append(newDataset)
                                    isPresentingNewDatasetView = false
                                    newDatasetContext.resetDatasetData()
                                    if UIDevice.isPad && datasets.count > 1 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                            selectedDatasetId = newDataset.id
                                        }
                                    }
                                }
                                .disabled(!newDatasetContext.isValidName)
                            }
                        }
                        .interactiveDismissDisabled()
                }
            }
        }

    }
}
