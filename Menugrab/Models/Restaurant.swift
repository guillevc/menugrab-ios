//
//  Restaurant.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI
import MapKit

struct Restaurant: Identifiable, Decodable, Equatable {
    private static let lengthFormatter: LengthFormatter = {
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
    
    let id: String
    let name: String
    let imageURL: String
    let coordinates: Coordinates
    let address: String
    let acceptingOrderTypes: [OrderType]
    let distance: Double?
    
    var formattedDistance: String? {
        guard let distance = distance else { return nil }
        if distance > 1 {
            return Self.lengthFormatter.string(fromValue: distance, unit: .kilometer)
        } else {
            return Self.lengthFormatter.string(fromValue: distance*1000, unit: .meter)
        }
    }
    
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
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(clLocationCoordinate2D: CLLocationCoordinate2D) {
        self.latitude = clLocationCoordinate2D.latitude
        self.longitude = clLocationCoordinate2D.longitude
    }
}
