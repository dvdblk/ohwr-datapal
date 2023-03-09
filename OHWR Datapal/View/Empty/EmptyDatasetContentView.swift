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
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(Color(uiColor: .secondarySystemFill))
            Text("Select a dataset")
                .font(.title)
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
