//
//  Restaurant.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI
import MapKit

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let image: Image
    let coordinate = CLLocationCoordinate2D(latitude: 43.3834, longitude: -8.3943)
    let acceptingOrderTypes: [OrderType]
    let menu: Menu
    
    var mapsURL: URL? {
        guard let nameWithPercentEncoding = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        let stringURL = "maps://?ll=\(coordinate.latitude),\(coordinate.longitude)&q=\(nameWithPercentEncoding)"
        return URL(string: stringURL)
    }
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
