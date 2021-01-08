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
    @State private var showingLocationSelector = false
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
            ZStack {
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
                        Button(action: {
                            withAnimation(.linear(duration: 0.15)) {
                                showingLocationSelector = true
                            }
                        }, label: {
                            HStack(spacing: 5) {
                                Text("Current location")
                                    .myFont(size: 17, weight: .bold)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 17))
                                    .foregroundColor(.myPrimary)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
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
                if (showingLocationSelector) {
                    let onDismissSelector = {
                        withAnimation(.linear(duration: 0.2)) {
                            showingLocationSelector = false
                        }
                    }
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.2)
                        .transition(.opacity)
                        .onTapGesture(perform: onDismissSelector)
                        .zIndex(1)
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            LocationSelectorView(onDismissSelector: onDismissSelector, bottomPadding: geometry.safeAreaInsets.bottom)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .zIndex(2)
                    .transition(.move(edge: .bottom))
                }
            }
            .navigationBarHidden(true)
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Filter restaurants"), message: nil, buttons: [
                    .default(Text("Show pickup")) {
                        appliedFilter = .pickup
                        showingActionSheet = false
                    },
                    .default(Text("Show table service")) {
                        appliedFilter = .table
                        showingActionSheet = false
                    },
                    .default(Text("Show all")) {
                        appliedFilter = nil
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

fileprivate struct LocationSelectorView: View {
    let onDismissSelector: (() -> ())?
    let bottomPadding: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack {
                    HStack(alignment: .center) {
                        Button(action: { onDismissSelector?() }) {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 17))
                                .foregroundColor(.myBlack)
                        }
                        Spacer()
                    }
                    Text("Search nearby")
                        .myFont(size: 15, weight: .bold)
                }
                .padding()
            }
            .cornerRadius(18)
            .clipped()
            LocationSelectorItemView(type: .currentLocation, isSelected: true)
                .padding(.horizontal)
                .padding(.vertical, 10)
            LocationSelectorItemView(type: .custom(name: "Avenida de arteixo"), isSelected: false)
                .padding(.horizontal)
                .padding(.vertical, 10)
            Divider()
                .opacity(0.5)
                .padding(.horizontal)
            SecondaryButtonView(text: "Add an address") {
                Image(systemName: "plus")
            }
            .padding()
        }
        .padding(.bottom, bottomPadding)
        .background(
            Color.white
                .shadow(radius: 20)
        )
    }
}

fileprivate enum LocationSelectorItemViewType {
    case currentLocation
    case custom(name: String)
}

fileprivate struct LocationSelectorItemView: View {
    let type: LocationSelectorItemViewType
    let isSelected: Bool
    
    private var text: String {
        if case let .custom(customText) = type {
            return customText
        } else {
            return "Current location"
        }
    }
    
    private var imageSystemName: String {
        if case .custom(_) = type {
            return "mappin.and.ellipse"
        } else {
            return "location"
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: imageSystemName)
                .font(.system(size: 18))
                .foregroundColor(.myBlack)
            Text(text)
                .myFont(size: 15)
            Spacer()
            Image(isSelected ? "radio_filled" : "radio")
                .renderingMode(.template)
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(isSelected ? .myPrimary : .myBlack)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
            LocationSelectorView(onDismissSelector: nil, bottomPadding: 0)
                .previewLayout(.sizeThatFits)
        }
    }
}
