//
//  EmptyDatasetDetailView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import SwiftUI

struct EmptyDatasetDetailView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 60))
                .foregroundColor(Color(uiColor: .secondarySystemFill))
            Text("Select a label to add new samples")
                .font(.title3)
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("")
    }
}

struct EmptyDatasetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDatasetDetailView()
    }
}
