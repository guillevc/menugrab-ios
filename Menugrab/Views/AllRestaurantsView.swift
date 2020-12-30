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
    private let restaurants = Restaurant.sampleRestaurants()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                            .foregroundColor(.myBlack)
                    }
                    Spacer()
                }
                Spacer()
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .foregroundColor(.myBlack)
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.size.width, height: 54)
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
            .navigationBarHidden(true)
        }
    }
}

struct HomeViewAllRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRestaurantsView(title: "Title")
    }
}
