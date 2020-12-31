//
//  Restaurant.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

enum OrderType {
    case table
    case pickup
}

struct Restaurant {
    let name: String
    let image: Image
    let acceptingOrderTypes: [OrderType]
}

extension Restaurant {
    static let sampleRestaurants: [Restaurant] = [
        .init(name: "San Tung", image: Image("santung"), acceptingOrderTypes: [.table]),
        .init(name: "Hamburguesería Buenosaires", image: Image("buenosaires"), acceptingOrderTypes: [.table, .pickup]),
        .init(name: "La Favola", image: Image("favola"), acceptingOrderTypes: [.table]),
        .init(name: "Los Farolillos", image: Image("farolillos"), acceptingOrderTypes: [.pickup])
    ]
}
