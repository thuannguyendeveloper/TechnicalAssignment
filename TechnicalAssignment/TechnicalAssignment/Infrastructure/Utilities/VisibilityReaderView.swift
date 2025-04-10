//
//  VisibilityReaderView.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

struct VisibilityReaderView<Content: View>: View {
    
    @Binding var isHidden: Bool
    
    let content: () -> Content
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    content()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct VisibilityPreferenceKey: PreferenceKey {
    
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
