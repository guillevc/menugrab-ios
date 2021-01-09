//
//  RestaurantDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct RestaurantMenuView: View {
    
    private static let initialImageHeight: CGFloat = 200
    fileprivate static let menuItemsHorizontalPadding: CGFloat = 16
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var basket: Basket
    
    let restaurant: Restaurant
    
    @State private var isHeaderVisible = false
    @State private var headerTopPadding: CGSize? = nil
    @State private var showingMoreInfoSheet = false
    
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
                                return AnyView(
                                    restaurant.image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: heightForHeaderImage(geometry))
                                        .clipped()
                                        .offset(x: 0, y: offsetForHeaderImage(geometry))
                                )
                            }
                        }
                        .frame(height: Self.initialImageHeight)
                        VStack(spacing: 0) {
                            RestaurantHeaderView(restaurant: restaurant, onMoreInfoButtonTapped: { showingMoreInfoSheet = true })
                                .padding(.horizontal)
                                .padding(.bottom)
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(restaurant.menu.itemCategories, id: \.name) { itemCategory in
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
                                        ForEach(itemCategory.items, id: \.name) { menuItem in
                                            MenuItemView(menuItem: menuItem)
                                        }
                                    }
                                    .padding(.bottom, 36)
                                }
                            }
                            .padding(.vertical)
                            .padding(.bottom, 50)
                        }
                        .padding(.top, -Self.initialImageHeight/2)
                    }
                }
                if !basket.items.isEmpty {
                    VStack {
                        Spacer()
                        BasketFloatingButtonView(totalQuantity: basket.totalQuantity, totalPrice: basket.totalPrice)
                    }
                    .padding(.bottom)
                }
                ZStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.myBlack)
                        }
                        Spacer()
                    }
                    Spacer()
                    Text(restaurant.name)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingMoreInfoSheet) {
            RestaurantMoreInfoView(restaurant: restaurant)
        }
    }
}

fileprivate struct RestaurantHeaderView: View {
    let restaurant: Restaurant
    let onMoreInfoButtonTapped: (() -> ())?
    
    var body: some View {
        VStack(spacing: 10) {
            Text(restaurant.name)
                .myFont(size: 23, weight: .bold)
            OrderTypeSegmentedPickerView()
            HStack(spacing: 16) {
                Text("13 km away")
                    .myFont(size: 13)
                Button(action: { onMoreInfoButtonTapped?() }) {
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
                Text("To start an order from the table, locate the label and scan it with your phone")
                    .myFont(size: 13)
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 26)
        .background(
            Color.white
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.15), radius: 8)
        )
    }
}

fileprivate struct OrderTypeSegmentedPickerView: View {
    private static let cornerRadius: CGFloat = 20
    @State private var currentOrderType = OrderType.table
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(OrderType.allCases, id: \.self) { type in
                let isSelected = currentOrderType == type
                HStack(spacing: 4) {
                    type.icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                    Text(type.rawValue)
                        .myFont(size: 15, weight: isSelected ? .bold : .regular)
                    
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
    }
}

fileprivate struct MenuItemView: View {
    private static let controlFrameWidth: CGFloat = 88
    private static let controlFrameHeight: CGFloat = 30
    private static let inBasketMarkWidth: CGFloat = 3
    
    @EnvironmentObject private var basket: Basket
    
    let menuItem: MenuItem
    
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
                        .lineLimit(nil)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 24) {
                Text("\(menuItem.price.formattedAmount ?? "-") €")
                    .myFont(size: 15, weight: .bold)
                if quantityInBasket > 0 {
                    HStack(spacing: 4) {
                        ModifyQuantityButton(action: { basket.decrementQuantityOfMenuItem(menuItem) }, type: .remove)
                        Text(String(quantityInBasket))
                            .myFont(size: 15, weight: .medium)
                            .frame(width: 22)
                        ModifyQuantityButton(action: { basket.incrementQuantityOfMenuItem(menuItem) }, type: .add)
                    }
                    .frame(width: Self.controlFrameWidth, height: Self.controlFrameHeight, alignment: .trailing)
                } else {
                    Button(action: { basket.incrementQuantityOfMenuItem(menuItem) }) {
                        Text("ADD")
                            .myFont(size: 15, weight: .bold, color: .myPrimary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color.myPrimaryLighter.cornerRadius(20))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: Self.controlFrameWidth, height: Self.controlFrameHeight, alignment: .trailing)
                    .clipped()
                }
            }
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
        RestaurantMenuView(restaurant: Restaurant.sampleRestaurants.first!)
            .environmentObject(Basket.sampleBasket)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
