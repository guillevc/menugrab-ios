//
//  OrdersService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/03/2021.
//

import Foundation
import SwiftUI
import Combine

protocol OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String)
    func createOrder(from basket: Basket) -> AnyPublisher<Order, Error>?
}

struct OrdersServiceImpl: OrdersService {
    let appState: Store<AppState>
    let webRepository: OrdersWebRepository
    
    init(appState: Store<AppState>, webRepository: OrdersWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        orders.wrappedValue.setIsLoading(bag: anyCancellableBag)

        webRepository.loadOrdersByUserId(userId: userId)
            .sinkToLoadable({ orders.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
    
    func createOrder(from basket: Basket) -> AnyPublisher<Order, Error>? {
        guard let createOrderDTO = CreateOrderDTO.init(from: basket) else { return nil }
        return webRepository.createOrder(createOrderDTO: createOrderDTO)
            .eraseToAnyPublisher()
    }
}

struct OrdersServiceStub: OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) { }
    func createOrder(from basket: Basket) -> AnyPublisher<Order, Error>? { return nil }
}
