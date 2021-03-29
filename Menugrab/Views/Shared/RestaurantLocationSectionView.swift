//
//  RestaurantLocationSectionView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 06/01/2021.
//

import SwiftUI

enum RestaurantLocationSectionViewType {
    case text
    case button
}

struct RestaurantLocationSectionView: View {
    let restaurant: Restaurant
    let type: RestaurantLocationSectionViewType
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "map")
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(restaurant.name)
                        .myFont(size: 15)
                    Spacer()
                    if type == .text {
                        LinkIfDestinationNotNull(destination: restaurant.mapsURL) {
                            Text("Get directions")
                                .myFont(size: 13, weight: .medium, color: .gray)
                        }
                    }
                }
                Text(restaurant.address)
                    .myFont(size: 13, color: .gray)
                Text("3 km away")
                    .myFont(size: 13, color: .gray)
            }
            if type == .button {
                LinkIfDestinationNotNull(destination: restaurant.mapsURL) {
                    Text("Directions")
                        .myFont(size: 13, weight: .medium, color: .myPrimary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color.myPrimaryLighter.cornerRadius(20))
            }
        }
    }
}

struct RestaurantLocationSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RestaurantLocationSectionView(restaurant: Restaurant.sampleRestaurants[0], type: .text)
            RestaurantLocationSectionView(restaurant: Restaurant.sampleRestaurants[1], type: .button)
        }
        .previewLayout(.sizeThatFits)
    }
}
