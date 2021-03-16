//
//  Basket.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import Foundation
import Combine

class Basket: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    let restaurant: Restaurant
    let orderType: OrderType

    @Published private(set) var items: [BasketItem] {
        didSet {
            subscribeToItemsChanges()
        }
    }
    
    var totalQuantity: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Decimal {
        items.reduce(Decimal.currency(0)) { $0.advanced(by: $1.totalPrice) }
    }
    
    init(restaurant: Restaurant, orderType: OrderType, items: [BasketItem] = []) {
        self.restaurant = restaurant
        self.orderType = orderType
        self.items = items
        subscribeToItemsChanges()
    }
    
    private func subscribeToItemsChanges() {
        for item in items {
            item.objectWillChange
                .sink(receiveValue: { _ in self.objectWillChange.send() })
                .store(in: &subscriptions)
        }
    }
    
    func quantityOfMenuItem(_ menuItem: MenuItem) -> Int {
        items.first(where: { $0.menuItem == menuItem })?.quantity ?? 0
    }
    
    func incrementQuantityOfMenuItem(_ menuItem: MenuItem) {
        if let basketItem = items.first(where: { $0.menuItem == menuItem }) {
            basketItem.quantity += 1
        } else {
            let newBasketItem = BasketItem(menuItem: menuItem)
            items.append(newBasketItem)
        }
    }
    
    func decrementQuantityOfMenuItem(_ menuItem:  MenuItem) {
        if let basketItemIndex = items.firstIndex(where: { $0.menuItem.name == menuItem.name }) {
            let basketItem = items[basketItemIndex]
            basketItem.quantity -= 1
            if basketItem.quantity == 0 {
                items.remove(at: basketItemIndex)
            }
        }
    }
    
}

class BasketItem: Decodable, ObservableObject {
    
    let menuItem: MenuItem
    @Published var quantity: Int
    
    init(menuItem: MenuItem, quantity: Int = 1) {
        self.menuItem = menuItem
        self.quantity = quantity
    }
    
    var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
    }
    
    // MARK: - Decodable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        menuItem = try container.decode(MenuItem.self, forKey: .menuItem)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }
    
    enum CodingKeys: CodingKey {
        case menuItem
        case quantity
    }

}
