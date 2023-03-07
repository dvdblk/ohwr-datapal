//
//  DatasetDetailView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct DatasetDetailView: View {
    @Binding var dataset: Dataset
    
    var body: some View {
        Text(dataset.name)
    }
}

struct DatasetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DatasetDetailView(dataset: .constant(Dataset.sampleData[0]))
    }
}
