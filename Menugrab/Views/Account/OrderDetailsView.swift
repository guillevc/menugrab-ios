//
//  OrderDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

enum OrderDetailsViewType {
    case completedOrder(Order)
    case currentOrder
}

struct OrderDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let viewModel: OrderDetailsViewModel
    let presentationType: CustomNavigationBarViewType
    let navigateToRestaurantAction: ((Restaurant) -> ())?
    let navigateToCompletedOrderAction: ((Order) -> ())?
    
    @State private var navigationBarTitle = "Order details"
    @State private var isRestaurantNavigationLinkActive = false
    
    private var orderInfoIcon: some View {
        var systemName: String
        
        switch viewModel.order.orderState {
        case .pending, .accepted:
            systemName = "doc.plaintext.fill"
        case .completed:
            systemName = "checkmark.circle.fill"
        case .canceled:
            systemName = "xmark.circle.fill"
        }
        
        return Image(systemName: systemName)
            .font(.system(size: 23))
            .foregroundColor(.myBlack)
            .eraseToAnyView()
    }
    
    private var orderInProgressIcon: some View {
        switch viewModel.order.orderState {
        case .pending:
            return ProgressView()
                .frame(width: 25, height: 25)
                .eraseToAnyView()
        case .accepted:
            return Image(systemName: "checkmark")
                .font(.system(size: 23))
                .foregroundColor(.myPrimary)
                .eraseToAnyView()
        case .completed, .canceled:
            return EmptyView()
                .eraseToAnyView()
        }
    }
    
    private var orderInProgressMessage: String? {
        switch viewModel.order.orderState {
        case .pending:
            return "Pending of approval by the restaurant"
        case .accepted:
            return "The restaurant accepted your order!"
        case .completed, .canceled:
            return nil
        }
    }
    
    private var orderCompletionDateMessage: String? {
        // TODO: add completion date from model
        if viewModel.order.orderState == .accepted {
            return "It will be ready at \(viewModel.order.date.timeFormatted)"
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: navigationBarTitle, type: presentationType, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Button(action: {
                        if presentationType != .notNavigable {
                            if let navigateToRestaurantAction = navigateToRestaurantAction {
                                navigateToRestaurantAction(viewModel.order.restaurant)
                            } else {
                                isRestaurantNavigationLinkActive = true
                            }
                        }
                    }) {
                        RestaurantNameTitleView(restaurantName: viewModel.order.restaurant.name, showChevronRight: presentationType != .notNavigable)
                            .padding(.horizontal, 5)
                            .padding(.vertical)
                    }
                    .buttonStyle(PlainButtonStyle())
                    if viewModel.order.isInProgress, let message = orderInProgressMessage {
                        HStack(spacing: 10) {
                            orderInProgressIcon
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message)
                                    .myFont(size: 15)
                                if let orderCompletionDateMessage = orderCompletionDateMessage {
                                    Text(orderCompletionDateMessage)
                                        .myFont(size: 15, weight: .semibold)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        Divider()
                            .light()
                            .padding(.horizontal)
                    }
                    HStack(spacing: 10) {
                        orderInfoIcon
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Order #\(viewModel.order.id)")
                                .myFont(size: 15)
                            Text("\(viewModel.order.date.formatted)")
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
                        viewModel.order.orderType.icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(viewModel.order.orderType == .pickup ? "Pick up order" : "Table order")
                            .myFont(size: 15)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    Divider()
                        .light()
                        .padding(.horizontal)
                    VStack(spacing: Constants.orderItemsListSpacing) {
                        ForEach(viewModel.order.orderItems, id: \.menuItem.name) { basketItem in
                            OrderItemView(orderItem: basketItem)
                        }
                        OrderItemsTotalPriceView(totalPrice: viewModel.order.totalPrice)
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
                            restaurant: viewModel.order.restaurant),
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
        Group {
            OrderDetailsView(viewModel: .init(container: .preview, type: .completedOrder(Order.sampleOrders.first(where: { $0.orderState == .pending })!)), presentationType: .default, navigateToRestaurantAction: nil, navigateToCompletedOrderAction: nil)
            OrderDetailsView(viewModel: .init(container: .preview, type: .completedOrder(Order.sampleOrders.first(where: { $0.orderState == .accepted })!)), presentationType: .default, navigateToRestaurantAction: nil, navigateToCompletedOrderAction: nil)
            OrderDetailsView(viewModel: .init(container: .preview, type: .completedOrder(Order.sampleOrders.first(where: { $0.orderState == .completed })!)), presentationType: .default, navigateToRestaurantAction: nil, navigateToCompletedOrderAction: nil)
            OrderDetailsView(viewModel: .init(container: .preview, type: .completedOrder(Order.sampleOrders.first(where: { $0.orderState == .canceled })!)), presentationType: .default, navigateToRestaurantAction: nil, navigateToCompletedOrderAction: nil)
        }
    }
}
