//
//  OHWR_DatapalApp.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

@main
struct OHWR_DatapalApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: - Data
    /// The array of datasets
    @State private var datasets = [Dataset]()
    /// Currently selected dataset
    @State private var selectedDatasetId: UUID? = nil
    /// Track previously selected dataset ID to seamlessly transition to previous dataset when scenePhase changes
    @State private var previouslySelectedDatasetId: UUID? = nil
    /// Currently selected label
    @State private var selectedLabelId: String? = nil
    /// Data for the dataset that should be created
    @StateObject private var newDatasetContext = NewDatasetContext()
    
    // MARK: UI
    @State private var splitViewColumnVisibility: NavigationSplitViewVisibility = .all
    @State private var isPresentingNewDatasetView = false
    
    /// Index of a dataset from its UUID
    func datasetIndex(with id: UUID?) -> Int? {
        return datasets.firstIndex(where: { $0.id == id })
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView(columnVisibility: $splitViewColumnVisibility) {
                DatasetListView(
                    datasets: $datasets,
                    selectedDatasetId: $selectedDatasetId,
                    isPresentingNewDatasetView: $isPresentingNewDatasetView
                )
            } content: {
                if let selectedDatasetId = selectedDatasetId, let datasetIdx = datasetIndex(with: selectedDatasetId) {
                    DatasetDetailView(dataset: $datasets[datasetIdx], selectedLabelId: $selectedLabelId, onDeleteAction: {
                        if let indexToRemove = datasetIndex(with: selectedDatasetId) {
                            self.selectedDatasetId = nil
                            // Delay is needed to avoid
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                datasets.remove(at: indexToRemove)
                            }
                        }
                    })
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
            .onChange(of: scenePhase) { phase in
                if phase == .background {
                    previouslySelectedDatasetId = selectedDatasetId
                } else if phase == .inactive && selectedDatasetId == nil {
                    selectedDatasetId = previouslySelectedDatasetId
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
                                    // Select this new dataset
                                    if UIDevice.isPad && datasets.count > 0 {
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
