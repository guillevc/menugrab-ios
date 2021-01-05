//
//  RestaurantDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct RestaurantDetailView: View {
    
    private static let initialImageHeight: CGFloat = 200
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var basket: Basket
    
    let restaurant: Restaurant
    
    @State var isHeaderVisible = false
    @State var headerTopPadding: CGSize? = nil
    
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
                            RestaurantHeaderView(restaurant: restaurant)
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
                                    Divider()
                                        .padding(.bottom, 12)
                                    VStack(alignment: .leading, spacing: 14) {
                                        ForEach(itemCategory.items, id: \.name) { menuItem in
                                            MenuItemView(menuItem: menuItem, basket: basket)
                                        }
                                    }
                                    .padding(.bottom, 24)
                                }
                            }
                            .padding()
                        }
                        .padding(.top, -Self.initialImageHeight/2)
                    }
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
                .frame(height: Constants.customNavbarHeight + topGeometry.safeAreaInsets.top, alignment: .bottom)
                .background(Color.white.opacity(isHeaderVisible ? 1 : 0))
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
}

fileprivate struct RestaurantHeaderView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(spacing: 10) {
            Text(restaurant.name)
                .myFont(size: 23, weight: .bold)
            OrderTypeSegmentedPickerView()
            HStack(spacing: 16) {
                Text("13 km away")
                    .myFont(size: 13)
                HStack(spacing: 4) {
                    Text("More info")
                        .myFont(size: 13, weight: .bold)
                    Image(systemName: "chevron.forward.2")
                        .font(Font.system(size: 9).weight(.bold))
                        .foregroundColor(.myPrimary)
                }
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
    let menuItem: MenuItem
    @ObservedObject var basket: Basket
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(menuItem.name)
                    .myFont(size: 15)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sed vestibulum nisi, sed iaculis metus.")
                    .myFont(size: 13, color: .darkGray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 24) {
                Text("\(menuItem.price.formattedAmount ?? "-") €")
                    .myFont(size: 15, weight: .bold)
                if let quantityInBasket = basket.quantityOfMenuItem(menuItem), quantityInBasket > 0 {
                    HStack(spacing: 4) {
                        ModifyQuantityButton(action: { basket.decrementQuantityOfMenuItem(menuItem) }, type: .remove)
                        Text(String(quantityInBasket))
                            .myFont(size: 15, weight: .medium)
                            .frame(width: 22)
                        ModifyQuantityButton(action: { basket.incrementQuantityOfMenuItem(menuItem) }, type: .add)
                        
                    }
                    .frame(width: Self.controlFrameWidth, alignment: .trailing)
                } else {
                    Button(action: { basket.incrementQuantityOfMenuItem(menuItem) }) {
                        Text("ADD")
                            .myFont(size: 15, weight: .bold, color: .myPrimary)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color.myPrimaryLighter.cornerRadius(20))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: Self.controlFrameWidth, alignment: .trailing)
                }
            }
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
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant.sampleRestaurants.first!)
            .environmentObject(Basket.sampleBasket)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
