//
//  AdvertisementRemoteDataSource.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

protocol AdvertisementRemoteDataSource: RemoteDataSource {
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError>
}

struct AdvertisementRemoteDataSourceImpl: AdvertisementRemoteDataSource {
    
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError> {
        request(with: APIEndpoint.fetchAdvertisements).eraseToAnyPublisher()
    }
}
