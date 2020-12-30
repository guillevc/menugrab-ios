//
//  HomeView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

struct HomeView: View {
    
    private static let allRestaurants = Restaurant.sampleRestaurants()
    
    @State private var restaurants = Self.allRestaurants.filter({ $0.acceptingOrderTypes.contains(.table) })
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "person")
                        .font(.system(size: 22))
                        .foregroundColor(.myBlack)
                    Spacer()
                    HStack(spacing: 5) {
                        Text("Current location")
                            .font(.custom("DM Sans", size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(.myBlack)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 17))
                            .foregroundColor(.myPrimary)
                    }
                    Spacer()
                    Image(systemName: "cart")
                        .font(.system(size: 22))
                        .foregroundColor(.myBlack)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.size.width, height: 54)
                Divider()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        NavigationLink(destination: HomeSearchView()) {
                            RestaurantSearchInputView(fontSize: 15, textFieldDisabled: true, showSlider: true, onSliderTapped: { showingActionSheet = true })
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        HeaderView(text: "Favourites ⭐")
                            .padding(.horizontal)
                            .padding(.bottom, -5)
                        HCarouselView(restaurants: restaurants)
                        HeaderView(text: "Nearby 📍")
                            .padding(.horizontal)
                            .padding(.top, 10)
                        ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                            RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                                .padding(.horizontal)
                                .padding(.top, 20)
                                .padding(.bottom, index == restaurants.count - 1 ? 20 : 0)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Filter restaurants"), message: nil, buttons: [
                    .default(Text("Show all")) {
                        restaurants = Self.allRestaurants
                        showingActionSheet = false
                    },
                    .default(Text("Show pickup")) {
                        restaurants = Self.allRestaurants.filter({ $0.acceptingOrderTypes.contains(.pickup) })
                        showingActionSheet = false
                    },
                    .default(Text("Show table service")) {
                        restaurants = Self.allRestaurants.filter({ $0.acceptingOrderTypes.contains(.table) })
                        showingActionSheet = false
                    },
                    .cancel()
                ])
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

fileprivate struct HCarouselView: View {
    
    let restaurants: [Restaurant]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                    RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                        .frame(width: 275, height: 125, alignment: .center)
                        .padding(.trailing, index == restaurants.count - 1 ? 20 : 0)
                }
            }
            .padding(.vertical, 25)
            .padding(.leading)
        }
    }
}

fileprivate struct HeaderView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(text)
                .font(.custom("DM Sans", size: 17))
                .fontWeight(.medium)
                .foregroundColor(.myBlack)
            Spacer()
            NavigationLink(destination: AllRestaurantsView()) {
                Text("View all")
                    .font(.custom("DM Sans", size: 13))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
