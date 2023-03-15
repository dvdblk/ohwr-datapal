//
//  NewDatasetView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI



class DatasetFileManager {
    
    func loadJSON(result: Result<[URL], Error>) -> Dataset.DataType? {
        do {
            guard
                let selectedFileURL = try? result.get().first,
                selectedFileURL.startAccessingSecurityScopedResource()
            else { return nil }
            let data = try Data(contentsOf: selectedFileURL)
            guard let datasetData = DatasetFileNDJSON.datasetDataFrom(data: data) else { return nil }
            selectedFileURL.stopAccessingSecurityScopedResource()
            return datasetData
        } catch {
            print(error)
        }
        return nil
    }
}

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
                        guard let importedDatasetData = DatasetFileManager().loadJSON(result: result) else { return }
                        print(importedDatasetData)
                        newDatasetContext.datasetData.data = importedDatasetData
                    }
                    if !newDatasetContext.datasetData.data.isEmpty {
                        List(labels, id: \.self) { label in
                            Text(label)
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("Importing data is optional. Format of the JSON data can be found [here](https://github.com/googlecreativelab/quickdraw-dataset#the-raw-moderated-dataset).")
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
