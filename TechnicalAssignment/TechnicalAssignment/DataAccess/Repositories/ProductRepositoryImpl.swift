//
//  ProductRepositoryImpl.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

struct ProductRepositoryImpl: ProductRepository {
    
    private let localDataSource: ProductLocalDataSource
    
    init(localDataSource: ProductLocalDataSource = ProductLocalDataSourceImpl()) {
        self.localDataSource = localDataSource
    }
    
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        localDataSource.fetchCurrentProductsPublisher()
    }
    
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        localDataSource.fetchPreviousProductsPublisher()
    }
    
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse> {
        localDataSource.fetchNextProductsPublisher()
    }
}
