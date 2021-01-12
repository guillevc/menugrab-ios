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
