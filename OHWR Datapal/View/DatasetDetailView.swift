//
//  DatasetDetailView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

/// Workaround for `@Environment(\.editMode)` not working in a single View
/// https://developer.apple.com/forums/thread/716434
private struct DatasetDetailContentView: View {
    @Environment(\.editMode) private var editMode
    @Binding var dataset: Dataset
    @State private var newLabelName = ""
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @ViewBuilder
    var labelsSection: some View {
        Section {
            ForEach(Array(dataset.data.keys).sorted(by: <), id: \.self) { label in
                NavigationLink(destination: SampleCreationView()) {
                    HStack {
                        Text(label)
                        Spacer()
                        Text("\(dataset.data[label]?.count ?? 0)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { indexSet in
                deleteLabel(at: indexSet)
            }
            if !isEditing {
                HStack {
                    TextField("New label", text: $newLabelName)
                    Button(action: {
                        withAnimation {
                            dataset.data.updateValue([], forKey: newLabelName)
                            newLabelName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newLabelName.isEmpty)
                }
                .deleteDisabled(true)
            }
        } header: {
            Text("Labels")
        }
    }
    
    var body: some View {
        Group {
            Section {
                HStack {
                    Text("Total # of samples")
                    Spacer()
                    Text("\(dataset.data.map({ $0.value }).joined().count)")
                        .foregroundColor(.secondary)
                }
                if isEditing {
                    Button {
                        // TODO: delete dataset
                    } label: {
                        Text("Delete dataset")
                            .foregroundColor(.red)
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .deleteDisabled(true)
            // workaround for a bug preventing .deleteDisabled(!isEditing) from reacting to changes of isEditing
            // https://stackoverflow.com/questions/73704545/swiftui-deletedisabled-is-not-working-as-expected/75678446#75678446
            if !isEditing {
                labelsSection
                .deleteDisabled(true)
            } else {
                labelsSection
                .deleteDisabled(false)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(dataset.name)
    }
    
    func deleteLabel(at indexSet: IndexSet) {
        for index in indexSet {
            for (i, key) in dataset.data.keys.sorted(by: <).enumerated() {
                if i == index {
                    dataset.data.removeValue(forKey: key)
                }
            }
        }
    }
}

struct DatasetDetailView: View {
    @Binding var dataset: Dataset
    
    var body: some View {
        Form {
            DatasetDetailContentView(dataset: $dataset)
        }
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            EditButton()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

struct DatasetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatasetDetailView(dataset: .constant(Dataset.sampleData[0]))
        }
    }
}
