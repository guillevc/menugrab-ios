//
//  Restaurant.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI
import MapKit

struct Restaurant: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let imageURL: String
    let coordinates: Coordinates
    let address: String
    let acceptingOrderTypes: [OrderType]
}

extension Restaurant {
    var mapsURL: URL? {
        guard let nameWithPercentEncoding = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        let stringURL = "maps://?ll=\(coordinates.latitude),\(coordinates.longitude)&q=\(nameWithPercentEncoding)"
        return URL(string: stringURL)
    }
}

struct Coordinates: Decodable, Equatable {
    let latitude: Double
    let longitude: Double
    
    var locationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
