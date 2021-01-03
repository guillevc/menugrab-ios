//
//  Restaurant.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

struct Restaurant {
    let name: String
    let image: Image
    let acceptingOrderTypes: [OrderType]
    let menu: Menu
}

// MARK: - Samples

extension Restaurant {
    static let sampleRestaurants: [Restaurant] = [
        .init(name: "San Tung", image: Image("santung"), acceptingOrderTypes: [.table], menu: Menu(itemCategories: Menu.sampleMenuItemCategories)),
        .init(name: "Hamburguesería Buenosaires", image: Image("buenosaires"), acceptingOrderTypes: [.table, .pickup], menu: Menu(itemCategories: [])),
        .init(name: "La Favola", image: Image("favola"), acceptingOrderTypes: [.table], menu: Menu(itemCategories: [])),
        .init(name: "Los Farolillos", image: Image("farolillos"), acceptingOrderTypes: [.pickup], menu: Menu(itemCategories: []))
    ]
}
