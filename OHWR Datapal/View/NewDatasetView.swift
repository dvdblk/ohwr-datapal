//
//  NewDatasetView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct NewDatasetView: View {
    @ObservedObject var newDatasetContext: NewDatasetContext
    @FocusState private var isNameFocused: Bool
    @State private var isPresentingImportMenu = false
    
    var labels: [String] {
        Array(newDatasetContext.datasetData.data.keys)
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Dataset Metadata") {
                    TextField("Dataset name", text: $newDatasetContext.datasetData.name)
                        .focused($isNameFocused)
                }
                Section {
                    Button {
                        isPresentingImportMenu = true
                    } label: {
                        Label("Import from JSON", systemImage: "square.and.arrow.down")
                    }
                    .fileImporter(
                        isPresented: $isPresentingImportMenu,
                        allowedContentTypes: [.json],
                        allowsMultipleSelection: false
                    ) { result in
                        guard let importedDatasetData = DatasetFileNDJSON.loadDatasetDataFromLocalFile(result: result) else { return }
                        newDatasetContext.datasetData.data = importedDatasetData
                    }
                    if !newDatasetContext.datasetData.data.isEmpty {
                        List(labels, id: \.self) { label in
                            HStack {
                                Text(label)
                                Spacer()
                                Text("\(newDatasetContext.datasetData.data[label]?.count.formatted() ?? "0")")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    if !newDatasetContext.datasetData.data.isEmpty {
                        Text("Loaded dataset data from file.")
                    } else {
                        Text("Importing data is optional. Format of the JSON data can be found [here](https://github.com/googlecreativelab/quickdraw-dataset#the-raw-moderated-dataset).")
                    }
                }
            }
        }
        .navigationTitle("New dataset")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isNameFocused = true
            }
        }
    }
}

struct NewDatasetView_Previews: PreviewProvider {
    static var previews: some View {
        NewDatasetView(newDatasetContext: NewDatasetContext())
    }
}
