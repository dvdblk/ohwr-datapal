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
    @State private var selectedDatasetId: UUID? = nil
    @State private var isPresentingNewDatasetView = false
    @State private var splitViewColumnVisibility: NavigationSplitViewVisibility = .all
    @StateObject private var newDatasetContext = NewDatasetContext()
    
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
                        VStack {
                            if let selectedDatasetId = selectedDatasetId, let datasetIndex = datasets.firstIndex(where: { $0.id == selectedDatasetId }) {
                                DatasetDetailView(dataset: $datasets[datasetIndex])
                            } else {
                                Text("Select dataset from Sidebar")
                            }
                        }
                    } detail: {
                        Text("Select label from dataset")
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
