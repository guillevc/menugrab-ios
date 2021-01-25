//
//  Order.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 03/01/2021.
//

import SwiftUI

enum OrderType: String, Decodable, CaseIterable {
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
//    let user: User
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
