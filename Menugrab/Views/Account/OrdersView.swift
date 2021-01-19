//
//  OrdersView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct OrdersView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let orders: [Order]
    
    var inProgressOrders: [Order] {
        orders.filter({ $0.isInProgress })
    }
    
    var completedOrders: [Order] {
        orders.filter({ !$0.isInProgress })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "My orders", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            OrderView(order: orders.first!)
            ScrollView {
                VStack(spacing: 18) {
                    OrderStateHeaderView(text: "In progress")
                        .padding(.horizontal)
                    ForEach(inProgressOrders, id: \.id) { order in
                        NavigationLink(destination: OrderDetailsView(order: order)) {
                            OrderCellView(order: order)
                                .padding(.horizontal)
                        }
                    }
                    Divider()
                        .padding(.horizontal)
                    OrderStateHeaderView(text: "Completed")
                        .padding(.horizontal)
                    ForEach(completedOrders, id: \.id) { order in
                        NavigationLink(destination: OrderDetailsView(order: order)) {
                            OrderCellView(order: order)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

fileprivate struct OrderStateHeaderView: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .myFont(size: 17, weight: .medium)
            Spacer()
        }
    }
}

fileprivate struct OrderCellView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 16) {
            Image("santung")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .clipped()
            VStack(alignment: .leading, spacing: 0) {
                Text(order.restaurant.name)
                    .myFont(size: 15, weight: .medium)
                    .padding(.bottom, 6)
                Text("\(order.totalQuantity) • \(order.totalPrice.formattedAmount ?? "-") €")
                    .myFont(size: 13, color: .darkGray)
                    .padding(.bottom, 4)
                Text(order.date.formatted())
                    .myFont(size: 13, color: .darkGray)
            }
            Spacer()
        }
    }
}

fileprivate struct OrderView: View {
    let order: Order
    var body: some View {
        HStack {
            
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(orders: Order.sampleOrders)
    }
}
