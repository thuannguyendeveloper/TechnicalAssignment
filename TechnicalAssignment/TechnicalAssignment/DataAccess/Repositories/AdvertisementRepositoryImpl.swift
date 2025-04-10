//
//  AdvertisementRepositoryImpl.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

struct AdvertisementRepositoryImpl: AdvertisementRepository {
    
    private let remoteDataSource: AdvertisementRemoteDataSource
    
    init(remoteDataSource: AdvertisementRemoteDataSource = AdvertisementRemoteDataSourceImpl()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError> {
        remoteDataSource.fetchAdvertisementsPublisher()
    }
}
