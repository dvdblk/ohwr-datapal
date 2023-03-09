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
    /// The dataset
    @Binding var dataset: Dataset
    /// Currently selected label of this dataset
    @Binding var selectedLabelId: String?
    /// Newly created label name
    @State private var newLabelName = ""
    @State private var exportFormat: DatasetFileFormat = .json
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @ViewBuilder
    var labelsSection: some View {
        Section {
            ForEach(Array(dataset.data.keys).sorted(by: <), id: \.self) { label in
                // Adds a chevron + keeps selection color
                // https://stackoverflow.com/a/72030978/4249857
                HStack {
                    HStack {
                        Text(label)
                        Spacer()
                        Text("\(dataset.data[label]?.count.formatted() ?? "0")")
                            .foregroundStyle(.secondary)
                    }.layoutPriority(1)
                    NavigationLink("", destination: EmptyView())
                }.listRowSeparator(.automatic)
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
        } footer: {
            if dataset.labels.isEmpty {
                Label("Start by adding new labels to the dataset...", systemImage: "lightbulb")
            }
        }
    }
    
    var body: some View {
        Group {
            Section {
                HStack {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 76, height: 76)
                        .foregroundColor(.accentColor)
                    Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                        GridRow(alignment: .firstTextBaseline) {
                            HStack {
                                Spacer()
                                Text("# of samples")
                                    .font(.headline)
                            }
                                .gridColumnAlignment(.leading)
                            Text("\(dataset.data.map({ $0.value }).joined().count.formatted())")
                                .foregroundColor(.secondary)
                                .font(.callout)
                                .gridColumnAlignment(.leading)
                        }
                        GridRow(alignment: .firstTextBaseline) {
                            HStack {
                                Spacer()
                                Text("# of labels")
                                    .font(.headline)
                            }
                            Text("\(dataset.labels.count.formatted())")
                                .foregroundColor(.secondary)
                                .font(.callout)
                        }
                    }
                }
                .minimumScaleFactor(0.78)
                .lineLimit(1)
                .padding()
                .padding(.leading, 08)
                .listRowInsets(EdgeInsets())
                .alignmentGuide(.listRowSeparatorLeading) { _ in return 0 }
                HStack {
                    Label("Created at", systemImage: "calendar")
                    Spacer()
                    Text(dataset.createdAt.formatted(.dateTime.day().month().year().hour().minute()))
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                Picker(selection: $exportFormat) {
                    ForEach(DatasetFileFormat.allCases) { format in
                        Text(format.rawValue).tag(format)
                    }
                } label: {
                    Label("Export format", systemImage: "doc.plaintext")
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
        .navigationTitle($dataset.name)
    }
    
    func deleteLabel(at indexSet: IndexSet) {
        for index in indexSet {
            for (i, key) in dataset.data.keys.sorted(by: <).enumerated() {
                if i == index {
                    dataset.data.removeValue(forKey: key)
                    if key == selectedLabelId {
                        selectedLabelId = nil
                    }
                }
            }
        }
    }
}

struct DatasetDetailView: View {
    @Binding var dataset: Dataset
    @Binding var selectedLabelId: String?
    /// Used to correctly identify selected labels from section 2
    @State private var heterogeneousSelection: String?
    
    var body: some View {
        List(selection: $selectedLabelId) {
            DatasetDetailContentView(dataset: $dataset, selectedLabelId: $selectedLabelId)
        }
        .listStyle(.insetGrouped)
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
            DatasetDetailView(dataset: .constant(Dataset.sampleData[0]), selectedLabelId: .constant(nil))
        }
    }
}
