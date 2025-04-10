//
//  Product.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

enum ProductType: String {
    case video = "video"
    case image = "image"
}

struct Product: Decodable {
    
    let id: String?
    let type: ProductType?
    let videoUrl: String?
    let imageUrl: String?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case videoUrl = "video_url"
        case imageUrl = "image_url"
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decode(String.self, forKey: .id)
        
        if let type = try? container.decode(String.self, forKey: .type) {
            self.type = ProductType(rawValue: type)
        } else {
            self.type = nil
        }
        
        self.videoUrl = try? container.decodeIfPresent(String.self, forKey: .videoUrl)
        self.imageUrl = try? container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.price = try? container.decodeIfPresent(Double.self, forKey: .price)
    }
}
