//
//  Order.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 03/01/2021.
//

import SwiftUI

enum OrderType: String, Decodable, Encodable, CaseIterable {
    case table = "ORDER_TYPE_TABLE"
    case pickup = "ORDER_TYPE_PICKUP"
    
    var label: String {
        switch self {
        case .table:
            return "Table"
        case .pickup:
            return "Pickup"
        }
    }
    
    var icon: Image {
        switch self {
        case .table:
            return Image("TableIcon")
        case .pickup:
            return Image("PickupIcon")
        }
    }
}

enum OrderState: String, Decodable, CaseIterable {
    case pending = "ORDER_STATE_PENDING"
    case accepted = "ORDER_STATE_ACCEPTED"
    case completed = "ORDER_STATE_COMPLETED"
    case canceled = "ORDER_STATE_CANCELED"
    
    var isInProgress: Bool {
        switch self {
        case .pending, .accepted:
            return true
        case .completed, .canceled:
            return false
        }
    }
}

struct Order: Identifiable, Decodable {
    let id: String
    let orderType: OrderType
    let date: Date
    let orderState: OrderState
    let restaurant: Restaurant
    let orderItems: [OrderItem]
    
    var totalQuantity: Int {
        orderItems.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Decimal {
        orderItems.reduce(Decimal.currency(0)) { $0.advanced(by: $1.totalPrice) }
    }
    
    var isInProgress: Bool {
        orderState.isInProgress
    }
}

struct OrderItem: Decodable {
    let menuItem: MenuItem
    let quantity: Int
    
    var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
    }
}

// MARK: - DTOs

struct CreateOrderDTO: Encodable {
    let restaurantId: String
    let orderType: OrderType
    let items: [CreateOrderItemDTO]
    
    init?(from basket: Basket) {
        guard let restaurant = basket.restaurant else { return nil }
        restaurantId = restaurant.id
        orderType = basket.orderType
        items = basket.items.map {
            return CreateOrderItemDTO(menuItemId: $0.menuItem.id, quantity: $0.quantity)
        }
    }
}

struct CreateOrderItemDTO: Encodable {
    let menuItemId: String
    let quantity: Int
}
