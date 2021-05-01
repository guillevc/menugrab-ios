//
//  BasketView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct BasketView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: BasketViewModel
    let navigateToRestaurantAction: (Restaurant) -> ()
    
    var body: some View {
        GeometryReader { geometry in
            let basket = viewModel.container.appState[\.basket]
            if let restaurant = basket.restaurant {
                VStack(spacing: 0) {
                    CustomNavigationBarView(title: "Your basket", type: .sheet, onDismiss: { presentationMode.wrappedValue.dismiss() })
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Button(action: { navigateToRestaurantAction(restaurant) }) {
                                RestaurantNameTitleView(restaurantName: restaurant.name)
                                .padding(.horizontal, 5)
                                .padding(.vertical)
                            }
                            HStack(spacing: 10) {
                                basket.orderType.icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text(basket.orderType == .pickup ? "Pick up the order at the restaurant" : "You will receive the order at your table")
                                    .myFont(size: 15)
                                Spacer()
                            }
                            .padding()
                            Divider()
                                .light()
                                .padding(.horizontal)
                            if basket.orderType == .pickup {
                                RestaurantLocationSectionView(restaurant: restaurant, type: .text)
                                    .padding()
                                Divider()
                                    .light()
                                    .padding(.horizontal)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                Text(basket.orderType == .pickup ? "You will notified with an estimate time to collect your order" : "You will notified with an estimate time of arrival")
                                    .myFont(size: 15)
                                Spacer()
                            }
                            .padding()
                            Color.backgroundGray
                                .frame(height: 8)
                            OrderItemsView(basket: basket, restaurant: restaurant, onNavigateToRestaurant: navigateToRestaurantAction)
                                .padding()
                            ZStack {
                                ZigZagBackgroundView(color: .backgroundGray, numberOfTriangles: 20, triangleHeight: 10)
                                Button(action: { viewModel.createOrderFromCurrentBasket() }) {
                                    ZStack {
                                        Color.myPrimary
                                            .cornerRadius(22)
                                            .frame(width: 325, height: 50, alignment: .center)
                                        if viewModel.orderRequestInProgress {
                                            ProgressView()
                                        } else {
                                            Text("Check out")
                                                .myFont(size: 17, weight: .bold, color: .black)
                                        }
                                    }
                                    .padding(.top, 40)
                                }
                                .disabled(viewModel.orderRequestInProgress || viewModel.container.appState[\.currentOrder] != nil)
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 24)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                            .background(Color.backgroundGray)
                        }
                        .background(Color.white)
                    }
                }
                .background(
                    VStack {
                        Color.white
                        Color.backgroundGray
                    }
                )
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

fileprivate struct OrderItemsView: View {
    private static let quantityFrameWidth: CGFloat = 26
    let basket: Basket
    let restaurant: Restaurant
    let onNavigateToRestaurant: (Restaurant) -> ()
    
    var body: some View {
        VStack(spacing: Constants.orderItemsListSpacing) {
            HStack {
                Text("Your order")
                    .myFont(size: 17, weight: .medium)
                Spacer()
                Button(action: { onNavigateToRestaurant(restaurant) }) {
                    Text("See the menu")
                        .myFont(size: 13, weight: .medium, color: .gray)
                }
            }
            ForEach(basket.items, id: \.menuItem.name) { basketItem in
                OrderItemView(orderItem: basketItem, quantityFrameWidth: Self.quantityFrameWidth)
            }
            HStack(spacing: 16) {
                Spacer().frame(width: Self.quantityFrameWidth)
                Button(action: { onNavigateToRestaurant(restaurant) }) {
                    SecondaryButtonView(text: "Add more items") {
                        Image(systemName: "plus")
                            .font(.system(size: 15))
                    }
                }
                Spacer()
            }
            .padding(.vertical, 6)
            Divider()
                .light()
            OrderItemsTotalPriceView(totalPrice: basket.totalPrice, quantityFrameWidth: Self.quantityFrameWidth)
        }
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView(viewModel: .init(container: .preview, navigateToCompletedOrderAction: { _ in }), navigateToRestaurantAction: { _ in })
            .previewDevice(.init(rawValue: "iPhone 11 Pro"))
    }
}
