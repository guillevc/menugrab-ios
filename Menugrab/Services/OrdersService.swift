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
    func createOrderFromBasket() -> AnyPublisher<Order, Error>?
    func loadCurrentOrder()
    func updateCurrentOrderStateUsingNotificationData(notificationData: CurrentOrderStateUpdateNotificationData)
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
    
    func createOrderFromBasket() -> AnyPublisher<Order, Error>? {
        guard let createOrderDTO = CreateOrderDTO.init(from: appState[\.basket]) else { return nil }
        
        let createOrderPublisher = webRepository.createOrder(createOrderDTO: createOrderDTO)
        
        createOrderPublisher.sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                print(error.localizedDescription)
            }
        }, receiveValue: { order in
            appState[\.basket].removeAllItems()
            appState[\.currentOrder] = order
        })
        .store(in: anyCancellableBag)
        
        return createOrderPublisher.eraseToAnyPublisher()
    }
    
    func loadCurrentOrder() {
        guard let userId = appState[\.currentUser]?.uid else { return }
        webRepository.loadCurrentOrder(userId: userId)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    appState[\.currentOrder] = nil
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
    
    func updateCurrentOrderStateUsingNotificationData(notificationData: CurrentOrderStateUpdateNotificationData) {
        guard let currentOrder = appState[\.currentOrder],
              currentOrder.id == notificationData.orderId else {
            print("Failed updateCurrentOrderStateUsingNotificationData")
            return
        }
        let newOrderState = notificationData.orderState
        print("Updating currentOrder from \(currentOrder.orderState.rawValue) to \(newOrderState.rawValue)")
        switch newOrderState {
        case .pending, .accepted:
            appState[\.currentOrder] = currentOrder.copy(with: notificationData.orderState)
        case .completed, .canceled:
            appState[\.currentOrder] = nil
        }
    }
}

struct OrdersServiceStub: OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) { }
    func createOrderFromBasket() -> AnyPublisher<Order, Error>? { return nil }
    func loadCurrentOrder() { }
    func updateCurrentOrderStateUsingNotificationData(notificationData: CurrentOrderStateUpdateNotificationData) { }
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
