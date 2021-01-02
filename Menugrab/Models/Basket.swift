//
//  Basket.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import Foundation

struct Basket {
    var items: [BasketItem]
    
    var totalQuantity: Int {
        items.reduce(0) { result, basketItem in
            result + basketItem.quantity
        }
    }
    
    var totalPrice: Decimal {
        items.reduce(Decimal.currency(0)) { result, basketItem in
            result.advanced(by: basketItem.totalPrice)
        }
    }
}

struct BasketItem {
    let quantity: Int
    let menuItem: MenuItem
    
    var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
    }
}

// MARK: - Decimal + Currency helper methods

extension Decimal {
    
    static func currency(_ value: Double) -> Self {
        NSNumber(floatLiteral: value).decimalValue
    }
    
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
    
}

// MARK: - Samples

extension Basket {
    static let sampleBasketItems: [BasketItem] = {
        [
            .init(quantity: 5, menuItem: .init(name: "Shrimp with Vermicelli and Garlic", price: Decimal.currency(18))),
            .init(quantity: 1, menuItem: .init(name: "Braised Pork Balls in Gravy", price: Decimal.currency(9.00))),
            .init(quantity: 3, menuItem: .init(name: "Bottle of water (50cl)", price: Decimal.currency(4.30))),
            .init(quantity: 2, menuItem: .init(name: "Peking Roasted Duck", price: Decimal.currency(19.50))),
            .init(quantity: 1, menuItem: .init(name: "Chow Mein", price: Decimal.currency(13.15)))
        ]
    }()
    
    static let sampleBasket: Self = {
        Self(items: Self.sampleBasketItems)
    }()
}
