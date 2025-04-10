//
//  Constants.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import UIKit

struct Device {
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let isIPhone = UIDevice.current.userInterfaceIdiom == .phone
}

struct APIConfigs {
    
    static let token = "2oIFeEXlXiENBgiyA1fMt5wkJnApcBMz76SCgKEsl34"
}
