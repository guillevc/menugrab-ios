//
//  Order.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 03/01/2021.
//

import SwiftUI

enum OrderType: String, CaseIterable {
    case table = "Table"
    case pickup = "Pickup"
    
    var icon: Image {
        switch self {
        case .table:
            return Image("TableIcon")
        case .pickup:
            return Image("PickupIcon")
        }
    }
}

enum OrderState {
    case pending
    case accepted
    case completed
    
    var isInProgress: Bool {
        switch self {
        case .pending, .accepted:
            return true
        case .completed:
            return false
        }
    }
}

struct Order {
    let id = UUID()
    let type: OrderType
    let date: Date
    let state: OrderState
    let user: User
    let restaurant: Restaurant
    let items: [BasketItem]
    
    var totalQuantity: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Decimal {
        items.reduce(Decimal.currency(0)) { $0.advanced(by: $1.totalPrice) }
    }
    
    var isInProgress: Bool {
        state.isInProgress
    }
}

// MARK: - Samples

extension Order {
    
    static let sampleOrders: [Order] = {
        let user = User(name: "Guille", email: "guille@asdsf.com", orders: [])
        return [
            Order(type: .pickup, date: Date.init(), state: .completed, user: user, restaurant: Restaurant.sampleRestaurants[0], items: Basket.sampleBasketItems),
            Order(type: .table, date: Date.init(), state: .pending, user: user, restaurant: Restaurant.sampleRestaurants[1], items: Basket.sampleBasketItems),
            Order(type: .table, date: Date.init(), state: .completed, user: user, restaurant: Restaurant.sampleRestaurants[2], items: Basket.sampleBasketItems)
        ]
    }()
    
}
