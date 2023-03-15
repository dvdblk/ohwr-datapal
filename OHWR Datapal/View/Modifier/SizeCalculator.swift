//
//  SizeCalculator.swift
//  OHWR Datapal
//
//  Created by David Bielik on 15/03/2023.
//

import SwiftUI

/// https://stackoverflow.com/a/57577752/4249857
struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            size = geometry.size
                        }
                        .onChange(of: geometry.size) { _ in
                            size = geometry.size
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
