//
//  Basket.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import Foundation
import Combine

struct Basket: Equatable {
    var restaurant: Restaurant?
    var orderType: OrderType
    var items: [BasketItem] = []
    
    var isValid: Bool {
        restaurant != nil && !items.isEmpty
    }
    
    var totalQuantity: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Decimal {
        items.reduce(Decimal.currency(0)) { $0.advanced(by: $1.totalPrice) }
    }
    
    func quantityOfMenuItem(_ menuItem: MenuItem) -> Int {
        items.first(where: { $0.menuItem == menuItem })?.quantity ?? 0
    }
    
    mutating func incrementQuantityOfMenuItem(_ menuItem: MenuItem) {
        if let basketItemIndex = items.firstIndex(where: { $0.menuItem == menuItem }) {
            items[basketItemIndex].quantity += 1
        } else {
            let newBasketItem = BasketItem(menuItem: menuItem)
            items.append(newBasketItem)
        }
    }
    
    mutating func decrementQuantityOfMenuItem(_ menuItem:  MenuItem) {
        if let basketItemIndex = items.firstIndex(where: { $0.menuItem.name == menuItem.name }) {
            items[basketItemIndex].quantity -= 1
            if items[basketItemIndex].quantity == 0 {
                items.remove(at: basketItemIndex)
            }
        }
    }
    
    mutating func removeAllItems() {
        items.removeAll()
    }
}



struct BasketItem: Equatable {
    let menuItem: MenuItem
    var quantity: Int
    
    init(menuItem: MenuItem, quantity: Int = 1) {
        self.menuItem = menuItem
        self.quantity = quantity
    }
    
    var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
    }
}
