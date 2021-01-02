//
//  HomeView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

struct HomeView: View {
    
    private static let allRestaurants = Restaurant.sampleRestaurants
    
    @State private var appliedFilter: OrderType?
    @State private var showingActionSheet = false
    @State private var showingBasketSheet = false
    
    private var restaurants: [Restaurant] {
        if let appliedFilter = appliedFilter {
            return Self.allRestaurants.filter({ $0.acceptingOrderTypes.contains(appliedFilter) })
        } else {
            return Self.allRestaurants
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "person")
                                .font(.system(size: 23))
                                .foregroundColor(.myBlack)
                        }
                        Spacer()
                        Button(action: { showingBasketSheet = true }) {
                            Image(systemName: "cart")
                                .font(.system(size: 23))
                                .foregroundColor(.myBlack)
                        }
                    }
                    HStack(spacing: 5) {
                        Text("Current location")
                            .myFont(size: 17, weight: .bold)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 17))
                            .foregroundColor(.myPrimary)
                    }
                }
                .padding()
                .frame(height: 54)
                Divider()
                    .opacity(0.5)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        NavigationLink(destination: HomeSearchView()) {
                            RestaurantSearchInputView(type: .display(onSliderTapped: { showingActionSheet = true }))
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        if let appliedFilter = appliedFilter {
                            HStack {
                                RestaurantFilterAppliedTagView(type: appliedFilter, onRemoveTapped: { self.appliedFilter = nil })
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        HeaderView(text: "Favourites ⭐", destination: AllRestaurantsView(title: "All our favourites"))
                            .padding(.horizontal)
                            .padding(.bottom, -5)
                        HCarouselView(restaurants: restaurants)
                        HeaderView(text: "Nearby 📍", destination: AllRestaurantsView(title: "All restaurants"))
                            .padding(.horizontal)
                            .padding(.top, 10)
                        ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .padding(.bottom, index == restaurants.count - 1 ? 20 : 0)
                            }.buttonStyle(IdentityButtonStyle())
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Filter restaurants"), message: nil, buttons: [
                    .default(Text("Show all")) {
                        appliedFilter = nil
                        showingActionSheet = false
                    },
                    .default(Text("Show pickup")) {
                        appliedFilter = .pickup
                        showingActionSheet = false
                    },
                    .default(Text("Show table service")) {
                        appliedFilter = .table
                        showingActionSheet = false
                    },
                    .cancel()
                ])
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingBasketSheet) {
            BasketView()
        }
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

fileprivate struct HeaderView<Destination: View>: View {
    let text: String
    let destination: Destination
    
    var body: some View {
        HStack(spacing: 0) {
            Text(text)
                .myFont(size: 17, weight: .medium)
            Spacer()
            NavigationLink(destination: destination) {
                Text("View all")
                    .myFont(size: 13, weight: .medium, color: .gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
