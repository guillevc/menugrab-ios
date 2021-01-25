//
//  Models+SampleData.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/01/2021.
//

import SwiftUI
import Foundation

extension Restaurant {
    static let sampleRestaurants: [Restaurant] = [
        .init(id: UUID().uuidString, name: "San Tung", imageURL: "https://i.imgur.com/QypqfcI.jpg", acceptingOrderTypes: [.table]),
        .init(id: UUID().uuidString, name: "Hamburguesería Buenosaires", imageURL: "https://i.imgur.com/QypqfcI.jpg", acceptingOrderTypes: [.table, .pickup]),
        .init(id: UUID().uuidString, name: "La Favola", imageURL: "https://i.imgur.com/QypqfcI.jpg", acceptingOrderTypes: [.table]),
        .init(id: UUID().uuidString, name: "Los Farolillos", imageURL: "https://i.imgur.com/QypqfcI.jpg", acceptingOrderTypes: [.pickup])
    ]
}

extension Order {
    
    static let sampleOrders: [Order] = {
//        let user = User(name: "Guille", email: "guille@asdsf.com", orders: [])
        return [
            Order(type: .pickup, date: Date.init(), state: .completed, restaurant: Restaurant.sampleRestaurants[0], items: Basket.sampleBasketItems),
            Order(type: .table, date: Date.init(), state: .pending, restaurant: Restaurant.sampleRestaurants[1], items: Basket.sampleBasketItems),
            Order(type: .table, date: Date.init(), state: .completed, restaurant: Restaurant.sampleRestaurants[2], items: Basket.sampleBasketItems)
        ]
    }()
    
}

extension Menu {
    static let sampleMenu = Menu(menuItemCategories: sampleMenuItemCategories)
    
    static let sampleMenuItemCategories: [MenuItemCategory] = {
        [
            MenuItemCategory(
                name: "Drinks",
                menuItems: [
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Bottle of water (50cl)",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        price: Decimal.currency(1.30)
                    ),
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Bottle of sprinkling water (50cl)",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        price: Decimal.currency(1.30)
                    )
                ]
            ),
            MenuItemCategory(
                name: "Starters",
                menuItems: [
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Chow Mein",
                        description: "Vivamus ac mattis magna. Mauris vel rutrum lectus.",
                        price: Decimal.currency(6.10)
                    ),
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Gyoza",
                        description: "Vivamus ac mattis magna. Mauris vel rutrum lectus.",
                        price: Decimal.currency(5.20)
                    )
                ]
            ),
            MenuItemCategory(
                name: "Main dishes",
                menuItems: [
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Rice noodles with spicey sauce",
                        description: nil,
                        price: Decimal.currency(6.25)
                    ),
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Sweet and sour chicken with lemon and chinese bread",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis elementum augue, non commodo elit. Aliquam faucibus purus eget diam accumsan, quis fermentum mauris.",
                        price: Decimal.currency(7)
                    ),
                    MenuItem(
                        id: UUID().uuidString,
                        name: "Peking Roasted Duck",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur et nibh lacus. In dapibus ac purus in placerat. Morbi eu purus quis mauris varius accumsan in facilisis eros. Vivamus ac mattis magna. Mauris vel rutrum lectus. Phasellus nunc ipsum, aliquet nec posuere interdum, porta vel lorem. Sed nec hendrerit libero.",
                        price: Decimal.currency(19.50)
                    )
                ]
            )
        ]
    }()
}

extension Basket {
    
    static let sampleBasketItems: [BasketItem] = {
        [
            .init(menuItem: Menu.sampleMenuItemCategories[0].menuItems[0], quantity: 5),
            .init(menuItem: Menu.sampleMenuItemCategories[0].menuItems[1], quantity: 1),
            .init(menuItem: Menu.sampleMenuItemCategories[1].menuItems[0], quantity: 3),
            .init(menuItem: Menu.sampleMenuItemCategories[2].menuItems[1], quantity: 2),
            .init(menuItem: Menu.sampleMenuItemCategories[2].menuItems[2], quantity: 1)
        ]
    }()
    
    static let sampleBasket: Basket = {
        Basket(restaurant: Restaurant.sampleRestaurants[0], orderType: .pickup, items: Basket.sampleBasketItems)
    }()
    
}

//extension User {
//    static let sampleUser = User(name: "Guillermo Varela", email: "guillermo.varela@email.com", orders: Order.sampleOrders)
//}
