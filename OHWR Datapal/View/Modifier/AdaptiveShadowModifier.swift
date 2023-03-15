//
//  AdaptiveShadowModifier.swift
//  OHWR Datapal
//
//  Created by David Bielik on 12/03/2023.
//

import SwiftUI

struct AdaptiveShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content.shadow(color: colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.4), radius: 4)
    }
}

extension View {
    func defaultShadow() -> some View {
        modifier(AdaptiveShadowModifier())
    }
}
