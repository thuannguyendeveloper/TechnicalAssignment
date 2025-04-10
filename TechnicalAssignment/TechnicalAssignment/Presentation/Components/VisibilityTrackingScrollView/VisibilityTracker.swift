//
//  VisibilityTracker.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

public enum VisibilityChange {
    case hidden
    case shown
}

final class VisibilityTracker<ID: Hashable>: ObservableObject {
    
    var containerBounds: CGRect
    var visibleViews: [ID:CGFloat]
    var sortedViewIDs: [ID]
    var action: Action
    var topVisibleView: ID? { sortedViewIDs.first }
    var bottomVisibleView: ID? { sortedViewIDs.last }
    typealias Action = (ID, VisibilityChange, VisibilityTracker<ID>) -> ()

    init(action: @escaping Action) {
        self.containerBounds = .zero
        self.visibleViews = [:]
        self.sortedViewIDs = []
        self.action = action
    }
    
    func sendContainerBounds(_ bounds: CGRect) {
        containerBounds = bounds
    }
    
    func sendContentBounds(_ bounds: CGRect, id: ID) {
        let topLeft = bounds.origin
        let size = bounds.size
        let bottomRight = CGPoint(x: topLeft.x + size.width, y: topLeft.y + size.height)
        let isVisible = containerBounds.contains(topLeft) || containerBounds.contains(bottomRight)
        let wasVisible = visibleViews[id] != nil

        if isVisible {
            visibleViews[id] = bounds.origin.y - containerBounds.origin.y
            sortViews()
            if !wasVisible {
                action(id, .shown, self)
            }
        } else {
            if wasVisible {
                visibleViews.removeValue(forKey: id)
                sortViews()
                action(id, .hidden, self)
            }
        }
    }
    
    func sortViews() {
        let sortedPairs = visibleViews.sorted(by: { $0.1 < $1.1 })
        sortedViewIDs = sortedPairs.map { $0.0 }
    }
}
