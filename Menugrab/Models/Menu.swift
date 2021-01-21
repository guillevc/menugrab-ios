//
//  MenuItem.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 31/12/2020.
//

import Foundation

struct Menu: Decodable {
    let menuItemCategories: [MenuItemCategory]
}

struct MenuItemCategory: Decodable {
    let name: String
    let menuItems: [MenuItem]
}

struct MenuItem: Equatable, Identifiable, Decodable {
    let id: String
    let name: String
    let description: String?
    let price: Decimal
}
