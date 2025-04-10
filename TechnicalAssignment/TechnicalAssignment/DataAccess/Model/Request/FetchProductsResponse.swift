//
//  FetchProductsResponse.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

struct FetchProductsResponse: Decodable {
    
    let items: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try? container.decode([Product].self, forKey: .items)
    }
}
