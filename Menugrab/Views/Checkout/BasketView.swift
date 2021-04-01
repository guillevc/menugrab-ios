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
    var navigateToRestaurantAction: (Restaurant) -> ()
    
    var body: some View {
        GeometryReader { geometry in
            let basket = viewModel.container.appState[\.basket]
            if let restaurant = basket.restaurant {
                VStack(spacing: 0) {
                    CustomNavigationBarView(title: "Your basket", type: .sheet, onDismiss: { presentationMode.wrappedValue.dismiss() })
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack {
                                Text(restaurant.name)
                                    .myFont(size: 23, weight: .bold)
                                    .background(
                                        VStack {
                                            Spacer()
                                            Color.myPrimaryLighter
                                                .frame(height: 5)
                                                .offset(x: 0, y: -7)
                                        }
                                    )
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 17))
                                    .foregroundColor(.myPrimary)
                                
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical)
                            HStack(spacing: 10) {
                                basket.orderType.icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text(basket.orderType == .pickup ? "Pick up the order at the restaurant" : "table number")
                                    .myFont(size: 15)
                                Spacer()
                            }
                            .padding()
                            Divider()
                                .light()
                                .padding(.horizontal)
                            RestaurantLocationSectionView(restaurant: restaurant, type: .text)
                                .padding()
                            Divider()
                                .light()
                                .padding(.horizontal)
                            HStack(spacing: 10) {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                Text("You will notified with an estimate time to collect your order")
                                    .myFont(size: 15)
                                Spacer()
                            }
                            .padding()
                            Divider()
                                .light()
                                .padding(.horizontal)
                            OrderItemsView(basket: basket, restaurant: restaurant, onNavigateToRestaurant: navigateToRestaurantAction)
                                .padding()
                            ZStack {
                                ZigZagBackgroundView(color: .backgroundGray, numberOfTriangles: 20, triangleHeight: 10)
                                Color.myPrimary
                                    .cornerRadius(16)
                                    .frame(width: 325, height: 50, alignment: .center)
                                    .overlay(
                                        Text("Check out")
                                            .myFont(size: 17, weight: .bold)
                                    )
                                    .padding(.top, 40)
                            }
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
        VStack(spacing: 8) {
            HStack {
                Text("Your order")
                    .myFont(size: 17, weight: .medium)
                Spacer()
                Text("See the menu")
                    .myFont(size: 13, weight: .medium, color: .gray)
            }
            ForEach(basket.items, id: \.menuItem.name) { basketItem in
                HStack(spacing: 16) {
                    Text("\(basketItem.quantity)x")
                        .myFont(size: 15)
                        .frame(width: Self.quantityFrameWidth, alignment: .trailing)
                    Text(basketItem.menuItem.name)
                        .myFont(size: 15)
                    Spacer()
                    Text("\(basketItem.totalPrice.formattedAmount ?? "-") €")
                        .myFont(size: 15)
                }
            }
            HStack(spacing: 16) {
                Spacer().frame(width: Self.quantityFrameWidth)
                Button(action: { onNavigateToRestaurant(restaurant) }) {
                    SecondaryButtonView(text: "Add more items") {
                        Image(systemName: "plus")
                            .font(.system(size: 17))
                    }
                }
                Spacer()
            }
            .padding(.vertical, 6)
            Divider()
                .light()
            HStack(spacing: 16) {
                Spacer().frame(width: Self.quantityFrameWidth)
                Text("Total")
                Spacer()
                //                Text("\(basket.totalPrice.formattedAmount ?? "-") €")
            }
            .myFont(size: 17, weight: .medium)
        }
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView(viewModel: .init(container: .preview), navigateToRestaurantAction: { _ in })
            .previewDevice(.init(rawValue: "iPhone 11 Pro"))
    }
}
