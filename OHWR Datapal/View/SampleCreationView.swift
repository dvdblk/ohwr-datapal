//
//  SampleCreationView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct SampleCreationView: View {
    let label: String
    @Binding var dataset: Dataset
    @Binding var splitViewColumnVisibility: NavigationSplitViewVisibility
    
    var body: some View {
        VStack {
            Text("Drawing")
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(label)
        }
        .toolbar {
            if UIDevice.isPad {
                ColumnVisibilityBarButton(splitViewColumnVisibility: $splitViewColumnVisibility)
            }
        }
    }
}

struct SampleCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SampleCreationView(label: "square", dataset: .constant(Dataset.sampleData[0]), splitViewColumnVisibility: .constant(.automatic))
        }
    }
}
