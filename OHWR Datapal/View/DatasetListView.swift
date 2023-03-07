//
//  ContentView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct DatasetListView: View {
    
    @Binding var datasets: [Dataset]
    @Binding var selectedDataset: Dataset?
    @Binding var isPresentingNewDatasetView: Bool
    @State private var newDatasetData = Dataset.Data()
    
    @ViewBuilder
    var listView: some View {
        if datasets.isEmpty {
            EmptyDatasetsView(isPresentingNewDatasetView: $isPresentingNewDatasetView)
        } else {
            List(selection: $selectedDataset) {
                ForEach($datasets) { $dataset in
                    NavigationLink(destination: DatasetDetailView(dataset: $dataset)) {
                        DatasetRow(dataset: dataset)
                    }.tag(dataset)
                }
            }
        }
    }

    var body: some View {
        listView
        .navigationTitle("Datasets")
        .toolbar {
            Button(action: {
                isPresentingNewDatasetView = true
            }) {
                Image(systemName: "plus.circle")
            }
            .accessibilityLabel("New Dataset")
        }
        .sheet(isPresented: $isPresentingNewDatasetView) {
            NavigationView {
                NewDatasetView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewDatasetView = false
                                newDatasetData = Dataset.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newDataset = Dataset(
                                    name: newDatasetData.name,
                                    data: newDatasetData.data
                                )
                                datasets.append(newDataset)
                                isPresentingNewDatasetView = false
                                newDatasetData = Dataset.Data()
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatasetListView(datasets: .constant(Dataset.sampleData), selectedDataset: .constant(Dataset.sampleData[0]), isPresentingNewDatasetView: .constant(false))
        }
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Landscape")
            .previewInterfaceOrientation(.landscapeLeft)
        
        NavigationView {
            DatasetListView(datasets: .constant([]), selectedDataset: .constant(nil), isPresentingNewDatasetView: .constant(false))
        }
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Portrait")
        
        NavigationView {
            DatasetListView(datasets: .constant(Dataset.sampleData), selectedDataset: .constant(nil), isPresentingNewDatasetView: .constant(false))
        }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone")
            
    }
}
