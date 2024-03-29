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
    fileprivate static let currentRestaurantViewHeight: CGFloat = 65
    
    @StateObject var viewModel: HomeViewModel
    
    @State private var showingLocationSelector = false
    @State private var showingActionSheet = false
    @State private var showingBasketSheet = false
    @State private var selectedRestaurantId: String? = nil
    @State private var activeFullScreenCover: FullScreenCoverItem? = nil
    
    private var locationSelectorButtonText: String {
        viewModel.container.appState[\.location] == nil ? "Select location" : "Current location"
    }
    
    private var lastRestaurantCellBottomPadding: CGFloat {
        viewModel.currentOrder == nil ? 20 : 20 + Self.currentRestaurantViewHeight
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
                                    .overlay(
                                        Color.myPrimary
                                            .clipShape(Circle())
                                            .frame(width: 9, height: 9)
                                            .padding(.leading, 22)
                                            .padding(.bottom, 18)
                                            .opacity(viewModel.basketIsValid && !viewModel.basketIsEmpty ? 1 : 0)
                                    )
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
                    if let restaurants = viewModel.filteredNearbyRestaurants.value {
                        nearbyRestaurantsLoadedView(restaurants: restaurants)
                    } else if let error = viewModel.filteredNearbyRestaurants.error {
                        Text("Failed: \(error.localizedDescription)")
                        Spacer()
                    } else {
                        nearbyRestaurantsLoadedView(restaurants: Restaurant.sampleRestaurants)
                            .redacted(reason: .placeholder)
                            .disabled(true)
                    }
                }
                
                if let currentOrder = viewModel.currentOrder {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            Button(action: {
                                activeFullScreenCover = .orderDetails(order: currentOrder)
                            }) {
                                OrderInProgressView(container: viewModel.container, order: currentOrder, height: Self.currentRestaurantViewHeight, safeAreaBottomInset: geometry.safeAreaInsets.bottom)
                            }
                            .buttonStyle(IdentityButtonStyle())
                        }
                        .edgesIgnoringSafeArea(.bottom)
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
                            LocationSelectorView(onDismissSelector: onDismissSelector, safeAreaBottomInset: geometry.safeAreaInsets.bottom)
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
                        selectedRestaurantId    = restaurant.id
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
                HomeSearchView(
                    container: viewModel.container,
                    restaurants: viewModel.filteredNearbyRestaurants.value ?? [],
                    navigateToRestaurantAction: { restaurant in
                        activeFullScreenCover = nil
                        selectedRestaurantId = restaurant.id
                    }
                )
            case .orderDetails:
                OrderDetailsView(
                    viewModel: .init(container: viewModel.container, type: .currentOrder),
                    presentationType: .sheet,
                    navigateToRestaurantAction: { restaurant in
                        activeFullScreenCover = nil
                        selectedRestaurantId = restaurant.id
                    },
                    navigateToCompletedOrderAction: nil
                )
            }
        }
        .onAppear {
            viewModel.resolveLocationPermissionStatus()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    private func nearbyRestaurantsLoadedView(restaurants: [Restaurant]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                RestaurantSearchInputView(type: .display(onSliderTapped: { showingActionSheet = true }), keywords: .constant(""))
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
                HCarouselView(restaurants: restaurants.filter({ $0.isFeatured }), container: viewModel.container, activeFullScreenCover: $activeFullScreenCover)
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
                            .padding(.bottom, index == restaurants.count - 1 ? lastRestaurantCellBottomPadding : 0)
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
    @Binding var activeFullScreenCover: FullScreenCoverItem?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(Array(restaurants.enumerated()), id: \.offset) { index, restaurant in
                    NavigationLink(
                        destination: RestaurantMenuView(
                            viewModel: .init(
                                container: container,
                                restaurant: restaurant
                            ),
                            navigateToCompletedOrderAction: { newOrder in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    activeFullScreenCover = .orderDetails(order: newOrder)
                                }
                            }
                        )
                    ) {
                        
                        RestaurantCellView(restaurant: restaurant, container: container)
                            .frame(width: 275, height: 125, alignment: .center)
                            .padding(.trailing, index == restaurants.count - 1 ? 20 : 0)
                    }
                    .buttonStyle(IdentityButtonStyle())
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
    let safeAreaBottomInset: CGFloat
    
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
        .padding(.bottom, safeAreaBottomInset)
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

fileprivate struct OrderInProgressView: View {
    let container: DIContainer
    let order: Order
    let height: CGFloat
    let safeAreaBottomInset: CGFloat
    
    var stateInformationString: String {
        switch order.orderState {
        case .pending:
            return "Order is waiting for approval from the restaurant"
        case .accepted:
            return "Order is being prepared"
        case .completed, .canceled:
            return "-"
        }
    }
    
    var body: some View {
        ZStack {
            Color.myPrimary
                .opacity(0.98)
            HStack(spacing: 16) {
                ZStack {
                    LoadableImageView(viewModel: .init(container: container, imageURLString: order.restaurant.imageURL))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipped()
                }
                VStack(alignment: .leading) {
                    Text(stateInformationString)
                        .myFont(size: 15, weight: .bold)
                    Text(order.restaurant.name)
                        .myFont()
                }
                Spacer()
                ProgressView()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .padding(.bottom, safeAreaBottomInset)
        }
        .frame(height: height + safeAreaBottomInset)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(viewModel: .init(container: .preview, nearbyRestaurants: Loadable.loaded(Restaurant.sampleRestaurants)))
            LocationSelectorView(onDismissSelector: nil, safeAreaBottomInset: 0)
                .previewLayout(.sizeThatFits)
        }
    }
}
