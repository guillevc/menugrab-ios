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
    
    func basketItemWithMenuItem(_ menuItem: MenuItem) -> BasketItem? {
        self.items.first(where: { $0.menuItem.name == menuItem.name }) // TODO: implement propper logic
    }
}

struct BasketItem {
    let menuItem: MenuItem
    var quantity: Int
    
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
            .init(menuItem: Menu.sampleMenuItemCategories[0].items[1], quantity: 5),
            .init(menuItem: Menu.sampleMenuItemCategories[0].items[2], quantity: 1),
            .init(menuItem: Menu.sampleMenuItemCategories[1].items[0], quantity: 3),
            .init(menuItem: Menu.sampleMenuItemCategories[1].items[3], quantity: 2),
            .init(menuItem: Menu.sampleMenuItemCategories[1].items[4], quantity: 1)
        ]
    }()
    
    static let sampleBasket: Self = {
        Self(items: Self.sampleBasketItems)
    }()
}
