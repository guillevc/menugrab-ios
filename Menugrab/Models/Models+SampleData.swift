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
        .init(name: "San Tung", image: Image("santung"), acceptingOrderTypes: [.table], menu: Menu(itemCategories: Menu.sampleMenuItemCategories)),
        .init(name: "Hamburguesería Buenosaires", image: Image("buenosaires"), acceptingOrderTypes: [.table, .pickup], menu: Menu(itemCategories: [])),
        .init(name: "La Favola", image: Image("favola"), acceptingOrderTypes: [.table], menu: Menu(itemCategories: [])),
        .init(name: "Los Farolillos", image: Image("farolillos"), acceptingOrderTypes: [.pickup], menu: Menu(itemCategories: []))
    ]
}

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

extension Menu {
    static let sampleMenuItemCategories: [MenuItemCategory] = {
        [
            MenuItemCategory(
                name: "Drinks",
                items: [
                    MenuItem(
                        name: "Chicken Hot Pot",
                        description: "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit",
                        price: Decimal.currency(14.3)
                    ),
                    MenuItem(
                        name: "Shrimp with Vermicelli and Garlic",
                        description: nil,
                        price: Decimal.currency(18)
                    ),
                    MenuItem(
                        name: "Braised Pork Balls in Gravy",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin id tempor augue. Pellentesque sollicitudin porttitor purus non imperdiet. Nullam non.",
                        price: Decimal.currency(9.00)
                    )
                ]),
            MenuItemCategory(
                name: "Starters",
                items: [
                    MenuItem(
                        name: "Bottle of water (50cl)",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        price: Decimal.currency(4.30)
                    ),
                    MenuItem(
                        name: "Rice noodles with spicey sauce",
                        description: nil,
                        price: Decimal.currency(6.25)
                    ),
                    MenuItem(
                        name: "Sweet and sour chicken with lemon and chinese bread",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sagittis elementum augue, non commodo elit. Aliquam faucibus purus eget diam accumsan, quis fermentum mauris.",
                        price: Decimal.currency(3.50)
                    ),
                    MenuItem(
                        name: "Peking Roasted Duck",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur et nibh lacus. In dapibus ac purus in placerat. Morbi eu purus quis mauris varius accumsan in facilisis eros. Vivamus ac mattis magna. Mauris vel rutrum lectus. Phasellus nunc ipsum, aliquet nec posuere interdum, porta vel lorem. Sed nec hendrerit libero.",
                        price: Decimal.currency(19.50)
                    ),
                    MenuItem(
                        name: "Chow Mein",
                        description: "Vivamus ac mattis magna. Mauris vel rutrum lectus.",
                        price: Decimal.currency(13.15)
                    )
                ])
        ]
    }()
}

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
        Basket(restaurant: Restaurant.sampleRestaurants[0], orderType: .pickup, items: Basket.sampleBasketItems)
    }()
    
}

extension User {
    static let sampleUser = User(name: "Guillermo Varela", email: "guillermo.varela@email.com", orders: Order.sampleOrders)
}
