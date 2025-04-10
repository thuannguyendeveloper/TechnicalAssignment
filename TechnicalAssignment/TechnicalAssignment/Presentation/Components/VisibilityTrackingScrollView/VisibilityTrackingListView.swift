//
//  VisibilityTrackingListView.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

struct VisibilityTrackingListView<Content, ID>: View where Content: View, ID: Hashable {
    
    @ViewBuilder let content: Content
    @State var visibilityTracker: VisibilityTracker<ID>
    
    init(action: @escaping VisibilityTracker<ID>.Action,
                @ViewBuilder content: () -> Content) {
        self.content = content()
        self._visibilityTracker = .init(initialValue: VisibilityTracker<ID>(action: action))
    }
    
    var body: some View {
        List {
            content.environmentObject(visibilityTracker)
        }
        .background(
            GeometryReader { proxy in
                send(proxy: proxy)
            }
        )
    }
    
    func send(proxy: GeometryProxy) -> Color {
        visibilityTracker.sendContainerBounds(proxy.frame(in: .global))
        return Color.clear
    }
    
}
