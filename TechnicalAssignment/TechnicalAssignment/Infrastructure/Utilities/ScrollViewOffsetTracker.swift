//
//  ScrollViewOffsetTracker.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

enum ScrollOffsetNamespace {
    
    static let namespace = "scrollView"
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct ScrollViewOffsetTracker: View {
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry
                        .frame(in: .named(ScrollOffsetNamespace.namespace))
                        .origin
                )
        }
        .frame(height: 0)
    }
}

extension ScrollView {
    
    func withOffsetTracking(action: @escaping (_ offset: CGPoint) -> Void) -> some View {
        self.coordinateSpace(name: ScrollOffsetNamespace.namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, 
                                perform: action)
    }
}
