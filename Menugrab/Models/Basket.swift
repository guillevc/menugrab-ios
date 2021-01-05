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
    
    @Published private(set) var items: [BasketItem] {
        didSet {
            subscribeToItemsChanges()
        }
    }
    
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
    
    init(items: [BasketItem]) {
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

class BasketItem: ObservableObject {
    
    let menuItem: MenuItem
    @Published var quantity: Int
    
    init(menuItem: MenuItem, quantity: Int = 1) {
        self.menuItem = menuItem
        self.quantity = quantity
    }
    
    var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
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
    
    static let sampleBasket: Basket = {
        Basket(items: Basket.sampleBasketItems)
    }()
    
}
