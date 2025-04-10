//
//  AdvertisementRepository.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

protocol AdvertisementRepository {
    func fetchAdvertisementsPublisher() -> AnyPublisher<[Advertisement], RequestError>
}
