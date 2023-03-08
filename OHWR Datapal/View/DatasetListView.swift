//
//  ContentView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct DatasetListView: View {
    
    @Binding var datasets: [Dataset]
    // Use selection ID instead of dataset to avoid Hashable conformance
    @Binding var selectedDatasetId: UUID?
    @Binding var isPresentingNewDatasetView: Bool
    
    @ViewBuilder
    var listView: some View {
        VStack(spacing: 0) {
            if datasets.isEmpty {
                EmptyDatasetsView(isPresentingNewDatasetView: $isPresentingNewDatasetView)
            } else {
                List(selection: $selectedDatasetId) {
                    ForEach($datasets.sorted(by: { $0.wrappedValue.name < $1.wrappedValue.name })) { $dataset in
                        DatasetRow(dataset: dataset).tag(dataset.id)
                    }
                }
            }
            
            Divider()
            Text("🌟 this app on [GitHub](https://github.com/dvdblk/ohwr-datapal)")
                .padding()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    var body: some View {
        listView
        .navigationTitle("Datasets")
        .toolbar {
            Button(action: {
                isPresentingNewDatasetView = true
            }) {
                Image(systemName: "doc.badge.plus")
            }
            .accessibilityLabel("New Dataset")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State private static var selectedDatasetId: UUID? = nil
    
    static var previews: some View {
        NavigationSplitView {
            DatasetListView(datasets: .constant(Dataset.sampleData), selectedDatasetId: $selectedDatasetId, isPresentingNewDatasetView: .constant(false))
        } content: {
            DatasetDetailView(dataset: .constant(Dataset.sampleData[0]))
        } detail: {
            SampleCreationView()
        }
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Landscape")
            .previewInterfaceOrientation(.landscapeLeft)

        NavigationView {
            DatasetListView(datasets: .constant([]), selectedDatasetId: $selectedDatasetId, isPresentingNewDatasetView: .constant(false))
        }
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewDisplayName("iPad Portrait")

        NavigationView {
            DatasetListView(datasets: .constant(Dataset.sampleData), selectedDatasetId: $selectedDatasetId,  isPresentingNewDatasetView: .constant(false))
        }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone")

    }
}
