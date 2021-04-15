//
//  OrderDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let viewModel: OrderDetailsViewModel
    let order: Order
    let presentationType: CustomNavigationBarViewType
    let navigateToRestaurantAction: ((Restaurant) -> ())?
    let navigateToCompletedOrderAction: ((Order) -> ())?
    
    @State private var navigationBarTitle = "Order details"
    @State private var isRestaurantNavigationLinkActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: navigationBarTitle, type: presentationType, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Button(action: {
                        if presentationType != .notNavigable {
                            if let navigateToRestaurantAction = navigateToRestaurantAction {
                                navigateToRestaurantAction(order.restaurant)
                            } else {
                                isRestaurantNavigationLinkActive = true
                            }
                        }
                    }) {
                        RestaurantNameTitleView(restaurantName: order.restaurant.name, showChevronRight: false)
                            .padding(.horizontal, 5)
                            .padding(.vertical)
                    }
                    .buttonStyle(PlainButtonStyle())
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 23))
                            .foregroundColor(.myBlack)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Order #\(order.id)")
                                .myFont(size: 15)
                            Text("\(order.date.formatted())")
                                .myFont(size: 13, color: .gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    Divider()
                        .light()
                        .padding(.horizontal)
                    HStack(spacing: 10) {
                        order.orderType.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(order.orderType == .pickup ? "Pick up order" : "Table order")
                            .myFont(size: 15)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    Divider()
                        .light()
                        .padding(.horizontal)
                    VStack(spacing: Constants.orderItemsListSpacing) {
                        ForEach(order.orderItems, id: \.menuItem.name) { basketItem in
                            OrderItemView(orderItem: basketItem)
                        }
                        OrderItemsTotalPriceView(totalPrice: order.totalPrice)
                            .padding(.top, 12)
                    }
                    .padding()
                    .background(Color.white)
                    ZigZagBackgroundView(color: .backgroundGray, numberOfTriangles: 20, triangleHeight: 10)
                }
            }
            .background(
                VStack(spacing: 0) {
                    Color.white
                    Color.backgroundGray
                    Color.backgroundGray
                }
            )
            .edgesIgnoringSafeArea(.bottom)
            if let navigateToCompletedOrderAction = navigateToCompletedOrderAction {
                NavigationLink(
                    destination: RestaurantMenuView(
                        viewModel: .init(
                            container: viewModel.container,
                            restaurant: order.restaurant),
                        navigateToCompletedOrderAction: { newOrder in
                            DispatchQueue.main.async {
                                isRestaurantNavigationLinkActive = false
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    navigateToCompletedOrderAction(newOrder)
                                }
                            }
                        }
                    ),
                    isActive: $isRestaurantNavigationLinkActive
                ) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(viewModel: .init(container: .preview), order: Order.sampleOrders.first!, presentationType: .default, navigateToRestaurantAction: nil, navigateToCompletedOrderAction: nil)
    }
}
