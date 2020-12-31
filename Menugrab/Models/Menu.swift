//
//  MenuItem.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 31/12/2020.
//

struct MenuItem {
    let name: String
    let price: String
}

struct BasketItem {
    let quantity: Int
    let menuItem: MenuItem
}

extension BasketItem {
    static let sampleBasketItems: [BasketItem] = [
        .init(quantity: 5, menuItem: .init(name: "Shrimp with Vermicelli and Garlic", price: "18,00 €")),
        .init(quantity: 1, menuItem: .init(name: "Braised Pork Balls in Gravy", price: "9,00 €")),
        .init(quantity: 3, menuItem: .init(name: "Bottle of water (50cl)", price: "4,00 €")),
        .init(quantity: 2, menuItem: .init(name: "Peking Roasted Duck", price: "20,00 €")),
        .init(quantity: 1, menuItem: .init(name: "Chow Mein", price: "12,00 €"))
    ]
}
