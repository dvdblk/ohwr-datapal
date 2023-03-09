//
//  ColumnVisibilityBarButton.swift
//  OHWR Datapal
//
//  Created by David Bielik on 09/03/2023.
//

import SwiftUI

struct ColumnVisibilityBarButton: ToolbarContent {
    @Binding var splitViewColumnVisibility: NavigationSplitViewVisibility
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                splitViewColumnVisibility = .detailOnly
            } label: {
                if splitViewColumnVisibility != .detailOnly {
                    Label("Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                }
            }
        }
    }
}
