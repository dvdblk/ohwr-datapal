//
//  EmptyDatasetContentView.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import SwiftUI

struct EmptyDatasetContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "doc.on.doc")
                .font(.system(size: 60))
                .foregroundColor(Color(uiColor: .secondarySystemFill))
            Text("Select a dataset")
                .font(.title2)
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("")
    }
}

struct EmptyDatasetContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDatasetContentView()
    }
}
