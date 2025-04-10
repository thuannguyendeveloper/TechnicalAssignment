//
//  HomeViewModel.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import Combine

extension HomeView {
    
    class ViewModel: ViewModelProvider {
        
        @Published var output = Output()
        
        private var cancellables = Set<AnyCancellable>()
        private var products: [Product] = [] {
            didSet {
                loadOutputData()
            }
        }
        private var advertisements: [Advertisement] = [] {
            didSet {
                loadOutputData()
            }
        }
        
        //MARK: - Interactors
        private let productInteractor: ProductInteractor
        private let advertisementsInteractor: AdvertisementsInteractor
        
        //MARK: - Initial
        init(productInteractor: ProductInteractor = ProductInteractor(),
             advertisementsInteractor: AdvertisementsInteractor = AdvertisementsInteractor()) {
            self.productInteractor = productInteractor
            self.advertisementsInteractor = advertisementsInteractor
        }
        
        enum Input: ViewModelInput {
            case fetchCurrentProducts
            case fetchPreviousProducts
            case fetchNextProducts
            case fetchAdvertisements
        }
        
        struct Output: ViewModelOutput {
            var data: [Any] = []
            var isLoadedPreviousPage = false
            var isLoadedCurrentPage = false
            var isLoadedNextPage = false
            var isFetchingAdvertisements = false
        }
        
        func transform(_ input: Input) {
            switch input {
            case .fetchCurrentProducts:
                fetchCurrentProducts()
            case .fetchPreviousProducts:
                fetchPreviousProducts()
            case .fetchNextProducts:
                fetchNextProducts()
            case .fetchAdvertisements:
                fetchAdvertisements()
            }
        }
        
        private func loadOutputData() {
            guard products.count > 0,
                  advertisements.count > 0 else { return }
            let orders = getAdvertisementFibonacciOrders(number: products.count)
            var data: [Any] = []
            data.append(contentsOf: products)
            for idx in 0..<advertisements.count {
                guard orders[idx] < products.count else { continue }
                data.insert(advertisements[idx], at: orders[idx])
            }
            output.data = data
        }
    }
}

extension HomeView.ViewModel {
    
    private func fetchCurrentProducts() {
        guard !output.isLoadedCurrentPage else { return }
        productInteractor.fetchCurrentProductsPublisher().sink { _ in } receiveValue: { [weak self] response in
            guard let self else { return }
            guard let products = response.result?.items else {
                self.output.isLoadedCurrentPage = false
                return
            }
            self.products = products
            output.isLoadedCurrentPage = true
        }.store(in: &cancellables)
    }
    
    private func fetchPreviousProducts() {
        guard output.isLoadedCurrentPage && !output.isLoadedPreviousPage else { return }
        productInteractor.fetchPreviousProductsPublisher().sink { _ in } receiveValue: { [weak self] response in
            guard let self else { return }
            guard products.count > 0 else {
                self.output.isLoadedPreviousPage = false
                return
            }
            let responseProducts = response.result?.items ?? []
            var products = self.products
            products.insert(contentsOf: responseProducts, at: 0)
            self.products = products
            output.isLoadedPreviousPage = true
        }.store(in: &cancellables)
    }
    
    private func fetchNextProducts() {
        guard output.isLoadedCurrentPage && !output.isLoadedNextPage else { return }
        productInteractor.fetchNextProductsPublisher().sink { _ in } receiveValue: { [weak self] response in
            guard let self else { return }
            guard products.count > 0 else {
                self.output.isLoadedNextPage = false
                return
            }
            let responseProducts = response.result?.items ?? []
            var products = self.products
            products.append(contentsOf: responseProducts)
            self.products = products
            output.isLoadedNextPage = true
        }.store(in: &cancellables)
    }
    
    private func fetchAdvertisements() {
        output.isFetchingAdvertisements = true
        advertisementsInteractor.fetchAdvertisementsPublisher().sink { _ in } receiveValue: { [weak self] response in
            guard let self else { return }
            output.isFetchingAdvertisements = false
            advertisements = response
        }.store(in: &cancellables)
    }
}

extension HomeView.ViewModel {
    
    private func getAdvertisementFibonacciOrders(number: Int) -> [Int]  {
        var orders = [Int]()
        for number in 0...number {
            switch number {
            case 0:
                orders.append(0)
            case 1:
                orders.append(1)
            default:
                orders.append(orders[number-1] + orders[number-2])
            }
        }
        
        var ordersSet = Set<Int>(orders)
        ordersSet.remove(0)
        let sortedOrders = Array(ordersSet).sorted()
        
        return sortedOrders
    }

    
    static func getItemHeight(itemOrder: Int, itemWidth: CGFloat) -> CGFloat {
        if Device.isIPhone {
            switch itemOrder {
            case 0, 3:
                return itemWidth + 30
            default:
                return itemWidth - 30
            }
        }
            
        switch itemOrder {
        case 0:
            return itemWidth + 80
        case 1:
            return itemWidth - 40
        case 2:
            return itemWidth + 10
        case 3:
            return itemWidth - 80
        case 4:
            return itemWidth + 40
        case 5:
            return itemWidth - 10
        default:
            return itemWidth
        }
    }
}
