//
//  HomeViewAllRestaurantsView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/12/2020.
//

import SwiftUI

struct AllRestaurantsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let title: String
    let restaurants: [Restaurant]
    let container: DIContainer
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: title, type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                        RestaurantCellView(restaurant: restaurant, container: container)
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .padding(.bottom, index == restaurants.count - 1 ? 20 : 0)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeViewAllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRestaurantsView(title: "Title", restaurants: Restaurant.sampleRestaurants, container: .preview)
    }
}
