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
    func loadCurrentOrder()
}

struct OrdersServiceImpl: OrdersService {
    let appState: Store<AppState>
    let webRepository: OrdersWebRepository
    let anyCancellableBag = AnyCancellableBag()
    
    init(appState: Store<AppState>, webRepository: OrdersWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) {
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
    
    func loadCurrentOrder() {
        guard let userId = appState[\.currentUser]?.uid else { return }
        webRepository.loadCurrentOrder(userId: userId)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    appState[\.displayedErrorMessage] = error.localizedDescription
                }
            }, receiveValue: { currentOrder in
                appState[\.currentOrder] = currentOrder
                // TODO: correct orderType
                print("current order received: \(currentOrder.id) from restaurant \(currentOrder.restaurant.name)")
                appState[\.basket] = Basket(orderType: .pickup)
            })
            .store(in: anyCancellableBag)
    }
}

struct OrdersServiceStub: OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) { }
    func createOrder(from basket: Basket) -> AnyPublisher<Order, Error>? { return nil }
    func loadCurrentOrder() { }
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
