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

enum OrderState: String, Decodable, CaseIterable {
    case pending = "ORDER_STATE_PENDING"
    case accepted = "ORDER_STATE_ACCEPTED"
    case completed = "ORDER_STATE_COMPLETED"
    
    var isInProgress: Bool {
        switch self {
        case .pending, .accepted:
            return true
        case .completed:
            return false
        }
    }
}

struct Order: Identifiable, Decodable {
    let id: String
    let orderType: OrderType
    let date: Date
    let orderState: OrderState
//    let user: User
    let restaurant: Restaurant
//    let menuItems: [BasketItem]
    
    var totalQuantity: Int {
        5
//        menuItems.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Decimal {
        10
//        menuItems.reduce(Decimal.currency(0)) { $0.advanced(by: $1.totalPrice) }
    }
    
    var isInProgress: Bool {
        orderState.isInProgress
    }
}
