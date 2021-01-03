//
//  Order.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 03/01/2021.
//

import SwiftUI

enum OrderType: String, CaseIterable {
    case table = "Table"
    case pickup = "Pickup"
    
    var icon: Image {
        switch self {
        case .table:
            return Image("table-icon")
        case .pickup:
            return Image("pickup-icon")
        }
    }
}
