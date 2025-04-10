//
//  Environments.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

protocol Environments {
    var baseURL: String { get }
}

struct Development: Environments {
    var baseURL: String = "https://api.unsplash.com/"
}

struct Initilization {
    static let currentEnviroment: Environments = Development()
}
