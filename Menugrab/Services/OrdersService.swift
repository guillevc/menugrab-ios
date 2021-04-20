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

// MARK: - DTOs

struct CreateOrderDTO: Encodable {
    let restaurantId: String
    let orderType: OrderType
    let table: Int?
    let items: [CreateOrderItemDTO]
    
    init?(from basket: Basket) {
        guard let restaurant = basket.restaurant else { return nil }
        restaurantId = restaurant.id
        orderType = basket.orderType
        if orderType == .table {
            guard let table = basket.table else { return nil }
            self.table = table
        } else {
            table = nil
        }
        items = basket.items.map {
            return CreateOrderItemDTO(menuItemId: $0.menuItem.id, quantity: $0.quantity)
        }
    }
}

struct CreateOrderItemDTO: Encodable {
    let menuItemId: String
    let quantity: Int
}
