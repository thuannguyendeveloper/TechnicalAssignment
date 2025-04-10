//
//  ProductRepository.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation

protocol ProductRepository {
    func fetchCurrentProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchPreviousProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
    func fetchNextProductsPublisher() -> ResponsePublisher<FetchProductsResponse>
}
