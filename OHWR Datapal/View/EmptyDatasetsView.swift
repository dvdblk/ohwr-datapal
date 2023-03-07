//
//  EmptyDatasetsView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 07/03/2023.
//

import SwiftUI

struct EmptyDatasetsView: View {
    @Binding var isPresentingNewDatasetView: Bool
    
    var body: some View {
        VStack {
            Text("You haven't created any datasets yet.")
                .padding(.top, 40)
            Button {
                isPresentingNewDatasetView = true
            } label: {
                Text("Create a dataset")
            }
                .padding()
                .buttonStyle(.borderedProminent)
        }
    }
}

struct EmptyDatasetsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDatasetsView(isPresentingNewDatasetView: .constant(false))
    }
}
