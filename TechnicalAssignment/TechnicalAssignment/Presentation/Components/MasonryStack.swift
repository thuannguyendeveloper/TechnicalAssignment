//
//  MasonryStack.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

struct MasonryStack: Layout {
    private var columns: Int
    private var spacing: Double
    
    init(columns: Int = 2, spacing: Double = 8.0) {
        self.columns = columns
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize {
        return calculateSize(for: subviews,
                             in: proposal)
    }
    
    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) {
        calculateSize(for: subviews,
                      in: proposal,
                      placeInBounds: bounds)
    }
    
    @discardableResult
    private func calculateSize(for subviews: Subviews,
                               in proposal: ProposedViewSize,
                               placeInBounds bounds: CGRect? = nil) -> CGSize {
        guard let maxWidth = proposal.width else { return .zero }
        let itemWidth = (maxWidth - spacing * Double(columns - 1)) / Double(columns)
        
        var xIndex: Int = 0
        var columnsHeights: [Double] = Array(repeating: bounds?.minY ?? 0, count: columns)
        
        for idx in 0..<subviews.count {
            let view = subviews[idx]
            let proposed = ProposedViewSize(
                width: itemWidth,
                height: view.sizeThatFits(.unspecified).height
            )
            
            if let bounds {
                let x = (itemWidth + spacing) * Double(xIndex) + bounds.minX
                view.place(at: .init(x: x, y: columnsHeights[xIndex]),
                           anchor: .topLeading,
                           proposal: proposed
                )
            }
            
            let height = view.dimensions(in: proposed).height
            columnsHeights[xIndex] += height + spacing
            xIndex = (idx + 1) % columns
        }
        
        guard let maxHeight = columnsHeights.max() else { return .zero }
        
        return .init(width: maxWidth,
                     height: maxHeight - spacing)
    }
    
    static var layoutProperties: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = .vertical
        return properties
    }
}
