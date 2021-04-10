//
//  RestaurantDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

fileprivate enum ActiveSheet: Identifiable {
    case moreInfo
    case basket
    
    var id: Int {
        hashValue
    }
}

struct RestaurantMenuView: View {
    fileprivate static let menuItemsHorizontalPadding: CGFloat = 16
    private static let initialImageHeight: CGFloat = 200
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: RestaurantMenuViewModel
    let navigateToCompletedOrderAction: (Order) -> ()
    
    @State private var isHeaderVisible = false
    @State private var headerTopPadding: CGSize? = nil
    @State private var activeSheet: ActiveSheet? = nil
    private var navigationBarDismissButtonHidden: Bool {
        #if APPCLIP
        return true
        #else
        return false
        #endif
    }
    
    private func scrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func offsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(geometry)
        return offset > 0 ? -offset : 0
    }
    
    private func heightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = scrollOffset(geometry)
        let imageHeight = geometry.size.height
        return offset > 0 ? imageHeight + offset : imageHeight
    }
    
    private func updateNavbarVisibility(imageGeometry: GeometryProxy, topGeometry: GeometryProxy) {
        if -scrollOffset(imageGeometry) >= (imageGeometry
                                                .size.height + topGeometry.safeAreaInsets.top - 60) {
            DispatchQueue.main.async {
                isHeaderVisible = true
            }
        } else {
            DispatchQueue.main.async {
                isHeaderVisible = false
            }
        }
    }
    
    var body: some View {
        GeometryReader { topGeometry in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        GeometryReader { geometry in
                            ZStack(alignment: .top) { () -> AnyView in
                                updateNavbarVisibility(imageGeometry: geometry, topGeometry: topGeometry)
                                return LoadableImageView(viewModel: .init(container: viewModel.container, imageURLString: viewModel.restaurant.imageURL))
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: heightForHeaderImage(geometry))
                                    .clipped()
                                    .offset(x: 0, y: offsetForHeaderImage(geometry))
                                    .eraseToAnyView()
                            }
                        }
                        .frame(height: Self.initialImageHeight)
                        VStack(spacing: 0) {
                            RestaurantHeaderView(basket: viewModel.basket, restaurant: viewModel.restaurant, onMoreInfoButtonTapped: { activeSheet = .moreInfo })
                                .padding(.horizontal)
                                .padding(.bottom)
                            if let menu = viewModel.menu.value {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(menu.menuItemCategories, id: \.name) { itemCategory in
                                        HStack {
                                            Spacer()
                                            Text(itemCategory.name.uppercased())
                                                .myFont(size: 13, color: .gray)
                                            Spacer()
                                        }
                                        .padding(.bottom, 6)
                                        .padding(.horizontal, Self.menuItemsHorizontalPadding)
                                        Divider()
                                            .padding(.horizontal, Self.menuItemsHorizontalPadding)
                                            .padding(.bottom, 20)
                                        VStack(alignment: .leading, spacing: 36) {
                                            ForEach(itemCategory.menuItems, id: \.name) { menuItem in
                                                MenuItemView(basket: viewModel.basket, restaurant: viewModel.restaurant, menuItem: menuItem, onIncrementQuantityTapped: { viewModel.incrementBasketQuantityOfMenuItem($0) }, onDecrementQuantityTapped: { viewModel.decrementBasketQuantityOfMenuItem($0) })
                                            }
                                        }
                                        .padding(.bottom, 36)
                                    }
                                }
                                .padding(.vertical)
                                .padding(.bottom, 50)
                            } else {
                                EmptyView()
                            }
                        }
                        .padding(.top, -Self.initialImageHeight/2)
                    }
                }
                if let basketRestaurant = viewModel.basket.restaurant, basketRestaurant == viewModel.restaurant, viewModel.basket.isValid {
                    VStack {
                        Spacer()
                        Button(action: { activeSheet = .basket }) {
                            BasketFloatingButtonView(totalQuantity: viewModel.basket.totalQuantity, totalPrice: viewModel.basket.totalPrice)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 24)
                }
                ZStack {
                    HStack {
                        #if APPCLIP
                        Text("")
                        #else
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        #endif
                        Spacer()
                    }
                    Spacer()
                    Text(viewModel.restaurant.name)
                        .myFont(size: 17, weight: .medium, color: .myBlack)
                        .opacity(isHeaderVisible ? 1 : 0)
                    Spacer()
                }
                .padding()
                .frame(height: Constants.customNavigationBarHeight + topGeometry.safeAreaInsets.top, alignment: .bottom)
                .background(Color.white.opacity(isHeaderVisible ? 1 : 0))
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadMenu()
            }
            .animation(.linear(duration: 0.1), value: viewModel.menu.value == nil)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $activeSheet) { item in
            switch item {
            case .moreInfo:
                RestaurantMoreInfoView(restaurant: viewModel.restaurant)
            case .basket:
                BasketView(
                    viewModel: .init(
                        container: viewModel.container,
                        navigateToCompletedOrderAction: { newOrder in
                            activeSheet = nil
                            presentationMode.wrappedValue.dismiss()
                            self.navigateToCompletedOrderAction(newOrder)
                        }
                    ),
                    navigateToRestaurantAction: { _ in
                        activeSheet = nil
                    }
                )
            }
            
        }
        .alert(isPresented: $viewModel.showingExistingBasketAlert) {
            Alert(
                title: Text("Do you want to clear your current basket?"),
                message: Text("Adding an item from this restaurant will clear your basket and you will lose all items added from \(viewModel.basket.restaurant?.name ?? "-")"),
                primaryButton: .default(Text("Add"), action: { viewModel.onExistingBasketAlertAccepted() }),
                secondaryButton: .cancel { viewModel.onExistingBasketAlertCanceled() }
            )
        }
    }
}

fileprivate struct RestaurantHeaderView: View {
    let basket: Basket
    let restaurant: Restaurant
    let onMoreInfoButtonTapped: () -> ()
    
    var infoMessage: String {
        switch basket.orderType {
        case .pickup:
            if restaurant.acceptingOrderTypes.contains(.table) {
                return "To start an order from the table, locate the label and scan it with your phone"
            } else {
                return "Make your order and collect it at the restaurant when it's ready"
            }
        case .table:
            return "Make your order and it will be delivered to your table"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Text(restaurant.name)
                .myFont(size: 23, weight: .bold)
                Spacer()
            }
            OrderTypeSegmentedPickerView(acceptingOrderTypes: restaurant.acceptingOrderTypes, currentOrderType: basket.orderType)
            HStack(spacing: 16) {
                switch basket.orderType {
                case .pickup:
                    if let formattedDistance = restaurant.formattedDistance {
                        Text("\(formattedDistance) away")
                            .myFont(size: 13)
                    }
                case .table:
                    Text("#13")
                        .myFont(size: 13)
                }
                Button(action: { onMoreInfoButtonTapped() }) {
                    HStack(spacing: 4) {
                        Text("More info")
                            .myFont(size: 13, weight: .medium)
                        Image(systemName: "chevron.forward.2")
                            .font(Font.system(size: 9).weight(.bold))
                            .foregroundColor(.myBlack)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            HStack(spacing: 10) {
                Image(systemName: "info.circle")
                    .font(Font.system(size: 15).weight(.regular))
                    .foregroundColor(.myBlack)
                Text(infoMessage)
                    .myFont(size: 13)
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 26)
        .background(
            Color.white
                .cornerRadius(22)
                .shadow(color: Color.black.opacity(0.12), radius: 24)
        )
    }
}

fileprivate struct OrderTypeSegmentedPickerView: View {
    private static let cornerRadius: CGFloat = 20
    let acceptingOrderTypes: [OrderType]
    @State var currentOrderType: OrderType
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(acceptingOrderTypes, id: \.self) { type in
                let isSelected = currentOrderType == type
                HStack(spacing: 4) {
                    type.icon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(isSelected ? .myBlack : .gray)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                    Text(type.label)
                        .myFont(size: 15, weight: isSelected ? .bold : .regular, color: isSelected ? .myBlack : .gray)
                    
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: Self.cornerRadius)
                        .foregroundColor(isSelected ? Color.myPrimaryLight : Color.clear)
                )
                .onTapGesture {
                    currentOrderType = type
                }
                .animation(.easeInOut(duration: 0.015))
            }
        }
        .background(Color.lightestGray).clipped()
        .cornerRadius(Self.cornerRadius)
        .disabled(true)
    }
}

fileprivate struct MenuItemView: View {
    private static let controlFrameWidth: CGFloat = 90
    private static let inBasketMarkWidth: CGFloat = 3
    
    let basket: Basket
    let restaurant: Restaurant
    let menuItem: MenuItem
    let onIncrementQuantityTapped: (MenuItem) -> ()
    let onDecrementQuantityTapped: (MenuItem) -> ()
    
    private var quantityInBasket: Int {
        basket.quantityOfMenuItem(menuItem)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(menuItem.name)
                        .myFont(size: 15)
                    Spacer()
                }
                if let description = menuItem.description {
                    Text(description)
                        .myFont(size: 13, color: .darkGray)
                        //                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 24) {
                Text("\(menuItem.price.formattedAmount ?? "-") €")
                    .myFont(size: 15, weight: .bold)
                
                if restaurant.acceptingOrderTypes.contains(basket.orderType) {
                    if quantityInBasket > 0 {
                        HStack(spacing: 4) {
                            ModifyQuantityButton(
                                action: { onDecrementQuantityTapped(menuItem) },
                                type: .remove
                            )
                            Text(String(quantityInBasket))
                                .myFont(size: 15, weight: .medium)
                                .frame(width: 22)
                            ModifyQuantityButton(
                                action: { onIncrementQuantityTapped(menuItem) },
                                type: .add
                            )
                        }
                    } else {
                        Button(action: { onIncrementQuantityTapped(menuItem) }) {
                            Text("ADD")
                                .myFont(size: 15, weight: .bold, color: .myPrimary)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 15)
                                .background(Color.myPrimaryLighter.cornerRadius(20))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(width: Self.controlFrameWidth, alignment: .topTrailing)
        }
        .padding(.horizontal, RestaurantMenuView.menuItemsHorizontalPadding)
        .overlay(
            HStack {
                if quantityInBasket > 0 {
                    Color.myPrimaryLight
                        .frame(width: Self.inBasketMarkWidth, alignment: .center)
                        .transition(.slide)
                    Spacer()
                }
            }
        )
    }
}

private struct ModifyQuantityButton: View {
    enum ModifyQuantityButtonType {
        case add
        case remove
    }
    
    let action: () -> ()
    let type: ModifyQuantityButtonType
    
    var body: some View {
        Button(action: action) {
            Image(systemName: type == .add ? "plus" : "minus")
                .myFont(size: 16, weight: .medium, color: .myPrimary)
                .frame(width: 30, height: 30)
                .background(Circle().foregroundColor(.myPrimaryLighter))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

fileprivate struct BasketFloatingButtonView: View {
    let totalQuantity: Int
    let totalPrice: Decimal
    
    var body: some View {
        HStack(spacing: 12) {
            Text(String(totalQuantity))
                .myFont(size: 17, weight: .medium)
                .frame(width: 30, height: 26)
                .background(
                    Color.myPrimaryDarker
                        .cornerRadius(4)
                )
            Text("View basket")
                .myFont(size: 17, weight: .bold)
            
            Spacer()
            Text("\(totalPrice.formattedAmount ?? "-") €")
                .myFont(size: 17, weight: .bold)
        }
        .padding(.horizontal, 22)
        .frame(width: 325, height: 50, alignment: .center)
        .background(
            Color.myPrimary
                .cornerRadius(16)
        )
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMenuView(
            viewModel: .init(
                container: .preview,
                restaurant: Restaurant.sampleRestaurants.first!,
                menu: .loaded(Menu.sampleMenu)
            ),
            navigateToCompletedOrderAction: { _ in }
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
