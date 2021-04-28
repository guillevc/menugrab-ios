//
//  OrdersView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

fileprivate enum FullScreenCoverItem: Identifiable {
    case orderDetails(order: Order)
    
    var id: String {
        switch self {
        case let .orderDetails(order):
            return "orderDetails[\(order.id)]"
        }
    }
}

struct OrdersView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: OrdersViewModel
    
    @State private var selectedOrderId: String? = nil
    @State private var activeFullScreenCover: FullScreenCoverItem? = nil
    
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
            case let .loaded(orders) where orders.isEmpty:
                OrdersEmptyView()
            case let .loaded(orders):
                ordersLoadedView(orders: orders)
            case let .failed(error):
                Text("Failed: \(error.localizedDescription)")
            }
            Spacer()
        }
        .fullScreenCover(item: $activeFullScreenCover, content: { item in
            switch item {
            case .orderDetails:
                OrderDetailsView(
                    viewModel: .init(container: viewModel.container, type: .currentOrder),
                    presentationType: .sheet,
                    navigateToRestaurantAction: nil,
                    navigateToCompletedOrderAction: { newOrder in
                        selectedOrderId = nil
                        
                        activeFullScreenCover = .orderDetails(order: newOrder)
                    }
                )
            }
        })
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func ordersLoadedView(orders: [Order]) -> some View {
        let inProgressOrders = orders.filter({ $0.isInProgress })
        let completedOrders = orders.filter({ !$0.isInProgress })
        
        return ScrollView {
            LazyVStack(spacing: 18) {
                if !inProgressOrders.isEmpty {
                    OrderStateHeaderView(text: "In progress")
                        .padding(.horizontal)
                    ForEach(inProgressOrders, id: \.id) { order in
                        orderCellView(order: order)
                    }
                }
                if !inProgressOrders.isEmpty && !completedOrders.isEmpty {
                    Divider()
                        .padding(.horizontal)
                }
                if !completedOrders.isEmpty {
                    OrderStateHeaderView(text: "Completed")
                        .padding(.horizontal)
                    ForEach(completedOrders, id: \.id) { order in
                        orderCellView(order: order)
                    }
                }
            }
        }
    }
    
    private func orderCellView(order: Order) -> some View {
        NavigationLink(
            destination: OrderDetailsView(
                viewModel: .init(container: viewModel.container, type: .completedOrder(order)),
                presentationType: .default,
                navigateToRestaurantAction: nil,
                navigateToCompletedOrderAction: { newOrder in
                    viewModel.loadUserOrders()
                    activeFullScreenCover = .orderDetails(order: newOrder)
                }
            ),
            tag: order.id,
            selection: $selectedOrderId
        ) {
            HStack(spacing: 16) {
                LoadableImageView(viewModel: .init(container: viewModel.container, imageURLString: order.restaurant.imageURL))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipped()
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(order.restaurant.name)\(order.orderState == .canceled ? " (canceled)" : "")")
                        .myFont(size: 15, weight: .medium)
                        .padding(.bottom, 6)
                    Text("\(order.totalQuantity) \(order.totalQuantity > 1 ? "items" : "item") ‒ \(order.totalPrice.formattedAmount ?? "-") €")
                        .myFont(size: 13, color: .darkGray)
                        .padding(.bottom, 4)
                    Text(order.date.formatted)
                        .myFont(size: 13, color: .darkGray)
                }
                Spacer()
            }
            .padding(.horizontal)
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

fileprivate struct OrdersEmptyView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text("No orders... yet")
                .myFont(size: 17, weight: .regular)
            Text("Start making orders and they will appear right here.")
                .myFont(size: 17, weight: .regular, color: .darkGray)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(viewModel: .init(container: .preview))
    }
}
