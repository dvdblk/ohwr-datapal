//
//  DatasetRow.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct DatasetRow: View {
    let dataset: Dataset
    
    var body: some View {
        Label(dataset.name, systemImage: "doc.on.doc")
    }
}

struct DatasetRow_Previews: PreviewProvider {
    static var previews: some View {
        DatasetRow(dataset: Dataset.sampleData[0])
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
