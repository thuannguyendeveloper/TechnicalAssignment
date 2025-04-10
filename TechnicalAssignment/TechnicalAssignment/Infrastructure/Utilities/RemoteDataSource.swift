//
//  RemoteDataSource.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine
import UIKit

enum RequestError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}

protocol RemoteDataSource {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, RequestError>
}

extension RemoteDataSource {
    
    func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, RequestError> where T: Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared
            .dataTaskPublisher(for: builder.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, RequestError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError {_ in .decodingError}
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: RequestError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: RequestError.unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
