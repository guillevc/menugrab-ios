//
//  HomeViewAllRestaurantsView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/12/2020.
//

import SwiftUI

struct AllRestaurantsView: View {
    
    let restaurants = Restaurant.sampleRestaurants()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                    RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, index == restaurants.count - 1 ? 20 : 0)
                }
            }
        }
        .navigationBarTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct HomeViewAllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRestaurantsView()
    }
}
