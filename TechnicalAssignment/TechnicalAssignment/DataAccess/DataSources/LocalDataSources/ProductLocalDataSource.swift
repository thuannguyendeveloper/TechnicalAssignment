//
//  ProductLocalDataSource.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

protocol ProductLocalDataSource: RemoteDataSource {
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
}

struct ProductLocalDataSourceImpl: ProductLocalDataSource {
    
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        fetchProductsFromLocalJsonFile(fileName: "current")
    }
    
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        fetchProductsFromLocalJsonFile(fileName: "prev")
    }
    
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        fetchProductsFromLocalJsonFile(fileName: "next")
    }
    
}

extension ProductLocalDataSource {
    
    private func getFileName(page: Int) -> String {
        switch page {
        case 0: return "prev"
        case 1: return "current"
        case 2: return "next"
        default: return ""
        }
    }
    
    fileprivate func fetchProductsFromLocalJsonFile(fileName: String) -> ResponsePublisher<FetchProductsResponse> {
        var data: Data?
        var response: Response<FetchProductsResponse>?
        
        return Future<Response<FetchProductsResponse>, RequestError> { promise in
            guard let file = Bundle.main.path(forResource: fileName, ofType: "json") else {
                return promise(.failure(RequestError.decodingError))
            }
            
            do {
                data = try String(contentsOfFile: file).data(using: .utf8)
            } catch {
                return promise(.failure(RequestError.decodingError))
            }
            
            guard let data else {
                return promise(.failure(RequestError.decodingError))
            }
            
            do {
                response = try JSONDecoder().decode(Response<FetchProductsResponse>.self, from: data)
            } catch {
                print(error.localizedDescription)
                return promise(.failure(RequestError.decodingError))
            }
            
            if let response {
                return promise(.success(response))
            }
            
            return promise(.failure(RequestError.decodingError))
        }.eraseToAnyPublisher()
    }
}
