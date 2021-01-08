//
//  RestaurantMoreInfoView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 06/01/2021.
//

import SwiftUI

let scheduleText =
"""
Monday - Friday
11:00 - 17:00
20:00 - 00:00

Saturday - Sunday
10:30 - 18:00
21:00 - 2:00
"""

struct RestaurantMoreInfoView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let restaurant: Restaurant
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(type: .sheet, title: "Restaurant info", onDismiss: { presentationMode.wrappedValue.dismiss() })
            ScrollView {
                VStack(spacing: 0) {
                    LinkIfDestinationNotNull(destination: restaurant.mapsURL) {
                        RestaurantMapView(restaurant: restaurant)
                            .frame(height: 200)
                    }
                    RestaurantLocationSectionView(restaurant: restaurant, type: .button)
                        .padding()
                    Divider()
                        .light()
                        .padding(.horizontal)
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                        Text(scheduleText)
                            .myFont(size: 15)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}

struct RestaurantMoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMoreInfoView(restaurant: Restaurant.sampleRestaurants.first!)
    }
}
