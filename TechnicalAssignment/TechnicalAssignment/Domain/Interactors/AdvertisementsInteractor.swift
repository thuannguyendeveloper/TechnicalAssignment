//
//  AdsInteractor.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

protocol AdsInterable {
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError>
}

struct AdvertisementsInteractor: AdsInterable {

    private let repository: AdvertisementRepository
    
    init(repository: AdvertisementRepository = AdvertisementRepositoryImpl()) {
        self.repository = repository
    }
    
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError> {
        repository.fetchAdvertisementsPublisher()
    }
}
