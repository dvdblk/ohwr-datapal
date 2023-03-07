//
//  OHWR_DatapalApp.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

@main
struct OHWR_DatapalApp: App {
    @State private var datasets = [Dataset]()
    @State private var selectedDataset: Dataset? = nil
    @State private var isPresentingNewDatasetView = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DatasetListView(datasets: $datasets, selectedDataset: $selectedDataset, isPresentingNewDatasetView: $isPresentingNewDatasetView)
                if let selection = selectedDataset {
                    DatasetDetailView(dataset: .constant(selection))
                } else {
                    EmptyDatasetsView(isPresentingNewDatasetView: $isPresentingNewDatasetView)
                }
            }
            .onAppear {
                // Select the first dataset if device is iPad and datasets are not empty
                if UIDevice.current.userInterfaceIdiom == .pad, !datasets.isEmpty {
                    selectedDataset = datasets[0]
                }
            }
            .onChange(of: datasets) { newDatasets in
                if selectedDataset == nil, UIDevice.current.userInterfaceIdiom == .pad, !newDatasets.isEmpty {
                    selectedDataset = newDatasets[0]
                }
            }
        }
    }
}
