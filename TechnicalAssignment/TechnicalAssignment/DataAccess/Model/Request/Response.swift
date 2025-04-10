//
//  Response.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

typealias ResponsePublisher<T: Decodable> = AnyPublisher<Response<T>, RequestError>

struct Response<T: Decodable>: Decodable {
    
    let statusCode: String?
    let message: String?
    let result: T?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try? container.decode(String.self, forKey: .statusCode)
        message = try? container.decode(String.self, forKey: .message)
        result = try? container.decode(T.self, forKey: .result)
    }
}
