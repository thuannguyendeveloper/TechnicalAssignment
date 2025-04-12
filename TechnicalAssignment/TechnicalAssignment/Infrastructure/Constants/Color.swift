//
//  Color.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

extension Color {
    
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}
