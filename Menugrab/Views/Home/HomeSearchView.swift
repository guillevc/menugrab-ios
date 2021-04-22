//
//  HomeSearchView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

struct HomeSearchView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let container: DIContainer
    let restaurants: [Restaurant]
    let navigateToRestaurantAction: (Restaurant) -> ()
    
    private var filteredRestaurants: [Restaurant] {
        guard keywords != "" else { return restaurants }
        return restaurants.filter {
            $0.name.localizedCaseInsensitiveContains(keywords)
        }
    }
    
    @State private var keywords = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.myBlack)
                }
                RestaurantSearchInputView(type: .input, keywords: $keywords)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(height: Constants.customNavigationBarHeight)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(filteredRestaurants) { restaurant in
                        Button(action: { navigateToRestaurantAction(restaurant) }) {
                            RestaurantCellView(restaurant: restaurant, container: container)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(IdentityButtonStyle())
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
                HomeSearchView(container: .preview, restaurants: Restaurant.sampleRestaurants, navigateToRestaurantAction: { _ in })
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
            }
        }
    }
}
