//
//  Advertisement.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Foundation

struct AdvertisementUrls: Decodable {
    
    let full: String?
    
    enum CodingKeys: String, CodingKey {
        case full
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let test = try? container.decodeIfPresent(String.self, forKey: .full)
        self.full = try? container.decodeIfPresent(String.self, forKey: .full)
    }
}

struct Advertisement: Decodable {
    
    let urls: AdvertisementUrls?
    
    enum CodingKeys: String, CodingKey {
        case urls
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let test = try? container.decode(AdvertisementUrls.self, forKey: .urls)
        self.urls = try? container.decode(AdvertisementUrls.self, forKey: .urls)
    }
}
