//
//  ProductInteractor.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

protocol ProductInterable {
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
}

struct ProductInteractor: ProductInterable {
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        repository.fetchCurrentProductsPublisher()
    }
    
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        repository.fetchPreviousProductsPublisher()
    }
    
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        repository.fetchNextProductsPublisher()
    }
}
