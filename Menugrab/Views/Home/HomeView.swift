//
//  HomeView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 28/12/2020.
//

import SwiftUI

fileprivate enum FullScreenCoverItem: Identifiable {
    case search
    case orderDetails(order: Order)
    
    var id: String {
        switch self {
        case .search:
            return "search"
        case let .orderDetails(order):
            return "orderDetails[\(order.id)]"
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var showingLocationSelector = false
    @State private var showingActionSheet = false
    @State private var showingBasketSheet = false
    @State private var selectedRestaurantId: String? = nil
    @State private var activeFullScreenCover: FullScreenCoverItem? = nil
    
    private var locationSelectorButtonText: String {
        viewModel.container.appState[\.location] == nil ? "Select location" : "Current location"
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            NavigationLink(destination: AccountView(viewModel: .init(container: viewModel.container))) {
                                Image(systemName: "person")
                                    .font(.system(size: 23))
                                    .foregroundColor(.myBlack)
                            }
                            Spacer()
                            Button(action: { showingBasketSheet = true }) {
                                Image(systemName: "cart")
                                    .font(.system(size: 23))
                                    .foregroundColor(viewModel.basketIsValid ? .myBlack : .lightGray)
                            }
                            .disabled(!viewModel.basketIsValid)
                        }
                        Button(action: {
                            withAnimation(.linear(duration: 0.15)) {
                                showingLocationSelector = true
                            }
                        }, label: {
                            HStack(spacing: 5) {
                                Text(locationSelectorButtonText)
                                    .myFont(size: 17, weight: .bold)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 17))
                                    .foregroundColor(.myPrimary)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    .frame(height: Constants.customNavigationBarHeight)
                    Divider()
                        .light()
                    if let restaurants = viewModel.nearbyRestaurants.value {
                        nearbyRestaurantsLoadedView(restaurants: restaurants)
                    } else if let error = viewModel.nearbyRestaurants.error {
                        Text("Failed: \(error.localizedDescription)")
                        Spacer()
                    } else {
                        nearbyRestaurantsLoadedView(restaurants: Restaurant.sampleRestaurants)
                            .redacted(reason: .placeholder)
                            .disabled(true)
                    }
                }
                if (showingLocationSelector) {
                    let onDismissSelector = {
                        withAnimation(.linear(duration: 0.2)) {
                            viewModel.requestLocationPermission()
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
            .sheet(isPresented: $showingBasketSheet) {
                BasketView(
                    viewModel: .init(
                        container: viewModel.container,
                        navigateToCompletedOrderAction: { newOrder in
                            showingBasketSheet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                activeFullScreenCover = .orderDetails(order: newOrder)
                            }
                        }
                    ),
                    navigateToRestaurantAction: { restaurant in
                        showingBasketSheet = false
                        selectedRestaurantId = restaurant.id
                    }
                )
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Filter restaurants"), message: nil, buttons: [
                .default(Text("Show pickup")) {
                    viewModel.appliedFilter = .pickup
                    showingActionSheet = false
                },
                .default(Text("Show table service")) {
                    viewModel.appliedFilter = .table
                    showingActionSheet = false
                },
                .default(Text("Show all")) {
                    viewModel.appliedFilter = nil
                    showingActionSheet = false
                },
                .cancel()
            ])
        }
        .fullScreenCover(item: $activeFullScreenCover) { item in
            switch item {
            case .search:
                HomeSearchView(container: viewModel.container, restaurants: viewModel.nearbyRestaurants.value ?? [])
            case let .orderDetails(createdOrder):
                OrderDetailsView(
                    viewModel: .init(container: viewModel.container),
                    order: createdOrder,
                    presentationType: .sheet,
                    navigateToRestaurantAction: { restaurant in
                        activeFullScreenCover = nil
                        selectedRestaurantId = restaurant.id
                    }
                )
            }
        }
        .onAppear {
            viewModel.resolveLocationPermissionStatus()
            viewModel.loadNearbyRestaurants()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    private func nearbyRestaurantsLoadedView(restaurants: [Restaurant]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                RestaurantSearchInputView(type: .display(onSliderTapped: { showingActionSheet = true }))
                    .onTapGesture {
                        activeFullScreenCover = .search
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                if let appliedFilter = viewModel.appliedFilter {
                    HStack {
                        RestaurantFilterAppliedTagView(type: appliedFilter, onRemoveTapped: { self.viewModel.appliedFilter = nil })
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                HeaderView(text: "Favourites ⭐", destination: AllRestaurantsView(title: "All our favourites", restaurants: restaurants, container: viewModel.container))
                    .padding(.horizontal)
                    .padding(.bottom, -5)
                HCarouselView(restaurants: restaurants, container: viewModel.container)
                HeaderView(text: "Nearby 📍", destination: AllRestaurantsView(title: "All restaurants", restaurants: restaurants, container: viewModel.container))
                    .padding(.horizontal)
                    .padding(.top, 10)
                ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                    NavigationLink(
                        destination: RestaurantMenuView(
                            viewModel: .init(
                                container: viewModel.container,
                                restaurant: restaurant
                            ),
                            navigateToCompletedOrderAction: { newOrder in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    activeFullScreenCover = .orderDetails(order: newOrder)
                                }
                            }
                        ),
                        tag: restaurant.id,
                        selection: $selectedRestaurantId
                    ) {
                        RestaurantCellView(restaurant: restaurant, container: viewModel.container)
                            .padding(.horizontal)
                            .padding(.top, 20)
                            .padding(.bottom, index == restaurants.count - 1 ? 20 : 0)
                    }
                    .buttonStyle(IdentityButtonStyle())
                }
            }
        }
    }
}

fileprivate struct HCarouselView: View {
    let restaurants: [Restaurant]
    let container: DIContainer
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                    RestaurantCellView(restaurant: restaurant, container: container)
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
            Button(
                action: { onDismissSelector?() }) {
                LocationSelectorItemView(type: .currentLocation, isSelected: true)
                    .padding()
            }
            LocationSelectorItemView(type: .custom(name: "Manually added address"), isSelected: false)
                .padding()
                .opacity(0.3)
            Divider()
                .light()
                .padding(.horizontal)
            SecondaryButtonView(text: "Add an address") {
                Image(systemName: "plus")
            }
            .padding()
            .opacity(0.3)
            .disabled(true)
        }
        .padding(.bottom, bottomPadding)
        .background(
            Color.white
                .shadow(radius: 20)
        )
        .clipShape(RoundedRectangleSpecificCorners(radius: 22, corners: [.topLeft, .topRight]))
        
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
        switch type {
        case let .custom(text):
            return text
        case .currentLocation:
            return "Current location"
        }
    }
    
    private var imageSystemName: String {
        switch type {
        case .custom:
            return "mappin.and.ellipse"
        case .currentLocation:
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: .init(container: .preview, nearbyRestaurants: Loadable.loaded(Restaurant.sampleRestaurants)))
            LocationSelectorView(onDismissSelector: nil, bottomPadding: 0)
                .previewLayout(.sizeThatFits)
        }
    }
}
