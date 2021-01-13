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

//  MARK: - DTOs

struct RestaurantDTO: Identifiable, Decodable {
    let id: String
    let name: String
    let imageURL: String
    let coordinates: Coordinates
    let acceptingOrderTypes: [String]
    let menu: MenuDTO
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}
