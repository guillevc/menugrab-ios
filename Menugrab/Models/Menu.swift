//
//  MenuItem.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 31/12/2020.
//

import Foundation

struct Menu {
    let itemCategories: [MenuItemCategory]
}

struct MenuItemCategory {
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Equatable {
    let name: String
    // TODO: add description
    let price: Decimal
}

// MARK: - Samples

extension Menu {
    static let sampleMenuItemCategories: [MenuItemCategory] = {
        [
            MenuItemCategory(
                name: "Drinks",
                items: [
                    MenuItem(name: "Chicken Hot Pot", price: Decimal.currency(14.3)),
                    MenuItem(name: "Shrimp with Vermicelli and Garlic", price: Decimal.currency(18)),
                    MenuItem(name: "Braised Pork Balls in Gravy", price: Decimal.currency(9.00))
                ]),
            MenuItemCategory(
                name: "Starters",
                items: [
                    MenuItem(name: "Bottle of water (50cl)", price: Decimal.currency(4.30)),
                    MenuItem(name: "Rice noodles with spicey sauce", price: Decimal.currency(6.25)),
                    MenuItem(name: "Fried rice", price: Decimal.currency(3.50)),
                    MenuItem(name: "Peking Roasted Duck", price: Decimal.currency(19.50)),
                    MenuItem(name: "Chow Mein", price: Decimal.currency(13.15))
                ])
        ]
    }()
}
