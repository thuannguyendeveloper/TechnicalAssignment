//
//  ContentVisibilityTrackingModifier.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

struct ContentVisibilityTrackingModifier<ID: Hashable>: ViewModifier {
    
    @EnvironmentObject var visibilityTracker: VisibilityTracker<ID>
    let id: ID
    
    func body(content: Content) -> some View {
        content
            .id(id)
            .background(
                GeometryReader { proxy in
                    send(proxy: proxy)
                }
            )
    }
    
    func send(proxy: GeometryProxy) -> Color {
        visibilityTracker.sendContentBounds(proxy.frame(in: .global), id: id)
        return Color.clear
    }
}

public extension View {
    
    func trackVisibility<ID: Hashable>(id: ID) -> some View {
        self.modifier(ContentVisibilityTrackingModifier(id: id))
    }
}
