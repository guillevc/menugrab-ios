//
//  OrdersView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct OrdersView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var viewModel: OrdersViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "My orders", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            switch viewModel.orders {
            case .notRequested:
                Text("NOT REQUESTED")
                    .onAppear {
                        viewModel.loadUserOrders()
                    }
                
            case .isLoading:
                ordersLoadedView(orders: Order.sampleOrders)
                    .redacted(reason: .placeholder)
                    .disabled(true)
            case let .loaded(orders):
                ordersLoadedView(orders: orders)
            case let .failed(error):
                Text("Failed: \(error.localizedDescription)")
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func ordersLoadedView(orders: [Order]) -> some View {
        let inProgressOrders = orders.filter({ $0.isInProgress })
        let completedOrders = orders.filter({ !$0.isInProgress })
        
        return ScrollView {
            VStack(spacing: 18) {
                OrderStateHeaderView(text: "In progress")
                    .padding(.horizontal)
                ForEach(inProgressOrders, id: \.id) { order in
                    NavigationLink(destination: OrderDetailsView(order: order)) {
                        orderCellView(order: order)
                            .padding(.horizontal)
                    }
                }
                Divider()
                    .padding(.horizontal)
                OrderStateHeaderView(text: "Completed")
                    .padding(.horizontal)
                ForEach(completedOrders, id: \.id) { order in
                    NavigationLink(destination: OrderDetailsView(order: order)) {
                        orderCellView(order: order)
                            .padding(.horizontal)
                    }
                }
            }
            Text(viewModel.orders.error?.localizedDescription ?? "")
        }
    }
    
    private func orderCellView(order: Order) -> some View {
        HStack(spacing: 16) {
            LoadableImageView(viewModel: .init(container: viewModel.container, imageURLString: order.restaurant.imageURL))
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .clipped()
            VStack(alignment: .leading, spacing: 0) {
                Text(order.restaurant.name)
                    .myFont(size: 15, weight: .medium)
                    .padding(.bottom, 6)
                Text("\(order.totalQuantity) \(order.totalQuantity > 1 ? "items" : "item") ‒ \(order.totalPrice.formattedAmount ?? "-") €")
                    .myFont(size: 13, color: .darkGray)
                    .padding(.bottom, 4)
                Text(order.date.formatted())
                    .myFont(size: 13, color: .darkGray)
            }
            Spacer()
        }
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

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: .init(container: .preview, orders: Loadable.loaded(Order.sampleOrders)))
    }
}
