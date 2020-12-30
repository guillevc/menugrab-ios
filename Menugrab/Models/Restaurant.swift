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
    static func sampleRestaurants() -> [Self] {
        [
            Self.init(name: "San Tung", image: Image("santung"), acceptingOrderTypes: [.table]),
            Self.init(name: "Hamburguesería Buenosaires", image: Image("buenosaires"), acceptingOrderTypes: [.table, .pickup]),
            Self.init(name: "La Favola", image: Image("favola"), acceptingOrderTypes: [.table]),
            Self.init(name: "Los Farolillos", image: Image("farolillos"), acceptingOrderTypes: [.pickup])
        ]
    }
}
