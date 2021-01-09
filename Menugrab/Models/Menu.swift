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
    let description: String?
    let price: Decimal
}

// MARK: - Samples

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
