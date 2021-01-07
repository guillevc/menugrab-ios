//
//  MapView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 06/01/2021.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {
    let restaurant: Restaurant
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [], annotationItems: [restaurant]) { restaurant in
            MapMarker(coordinate: restaurant.coordinate, tint: .myPrimaryDark)
        }
        .onAppear {
            region = MKCoordinateRegion(
                center: restaurant.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMapView(restaurant: Restaurant.sampleRestaurants.first!)
    }
}
