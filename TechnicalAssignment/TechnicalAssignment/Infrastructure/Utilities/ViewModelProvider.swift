//
//  ViewModelProvider.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Combine
import Foundation
import SwiftUI

protocol ViewModelOutput {}

protocol ViewModelInput {}

protocol ViewModelProvider: ObservableObject {
    
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput

    var output: Output { get set }

    func transform(_ input: Input)
}
