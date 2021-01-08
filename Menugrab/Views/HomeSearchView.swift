//
//  HomeSearchView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

struct HomeSearchView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let restaurants = Restaurant.sampleRestaurants
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.myBlack)
                }
                RestaurantSearchInputView(type: .input)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(height: Constants.customNavigationBarHeight)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                        RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(["iPhone 11 Pro", "iPhone SE (2nd generation)"], id: \.self) { deviceName in
                HomeSearchView().previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
