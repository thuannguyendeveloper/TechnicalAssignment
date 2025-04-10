//
//  APIEndpoint.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

protocol RequestBuilder {
    var urlRequest: URLRequest { get }
}

enum APIEndpoint {
    
    case fetchAdvertisements
    
    private var baseURL: String {
        Initilization.currentEnviroment.baseURL
    }
    
    var endpoint: String {
        switch self {
        case .fetchAdvertisements:
            baseURL + "photos"
        }
    }
}

extension APIEndpoint: RequestBuilder {
    
    var urlRequest: URLRequest {
        let queryItems = [URLQueryItem(name: "client_id", value: APIConfigs.token)]
        guard var components = URLComponents(string: endpoint) else {
            fatalError()
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError()
        }
        let request = URLRequest(url: url)
        
        return request
    }
}
