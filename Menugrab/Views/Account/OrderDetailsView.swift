//
//  OrderDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let order: Order
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Order details", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    RestaurantNameTitleView(restaurantName: order.restaurant.name)
                        .padding(.horizontal, 5)
                        .padding(.vertical)
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
                VStack {
                    Color.white
                    Color.backgroundGray
                }
            )
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(order: Order.sampleOrders.first!)
    }
}
