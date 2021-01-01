//
//  BasketView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct BasketView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        HStack(alignment: .center) {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                                    .foregroundColor(.myBlack)
                            }
                            Spacer()
                        }
                        Text("Your basket")
                            .myFont(size: 17, weight: .medium)
                    }
                    .padding()
                    .frame(height: 48)
                    Divider()
                        .opacity(0.3)
                    ScrollView {
                        VStack {
                            HStack {
                                Text("San Tung")
                                    .myFont(size: 23, weight: .bold)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 17))
                                    .foregroundColor(.myPrimary)
                                
                            }
                            .padding(.horizontal, 5)
                            .background(
                                VStack {
                                    Spacer()
                                    Color.myPrimaryLight
                                        .frame(height: 5)
                                        .offset(x: 0, y: -7)
                                }
                            )
                            .padding(.vertical)
                            HStack(spacing: 10) {
                                Image("pickup-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text("Pick up the order at the restaurant")
                                    .myFont(size: 15)
                                Spacer()
                            }.padding(.horizontal)
                            Divider().opacity(0.5).padding(.horizontal)
                            HStack(spacing: 10) {
                                Image(systemName: "map")
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("San Tung")
                                            .myFont(size: 15)
                                        Spacer()
                                        Text("View map")
                                            .myFont(size: 13, weight: .medium, color: .gray)
                                    }
                                    Text("Wolf Crater, 897, Marsh")
                                        .myFont(size: 13, color: .gray)
                                    Text("3 km away")
                                        .myFont(size: 13, color: .gray)
                                }
                            }.padding(.horizontal)
                            Divider().opacity(0.5).padding(.horizontal)
                            HStack(spacing: 10) {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                Text("You will notified with an estimate time to collect your order")
                                    .myFont(size: 15)
                                Spacer()
                            }.padding(.horizontal)
                            Color.lightestGray.frame(height: 8).opacity(0.5)
                            OrderItemsView()
                                .padding()
                            ZStack {
                                ZigZagBackgroundView(color: Color.lightestGray, numberOfTriangles: 20, triangleHeight: 10)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(Color.myPrimary)
                                    .frame(width: 325, height: 50, alignment: .center)
                                    .overlay(
                                        HStack {
                                            Text("Check out")
                                                .myFont(size: 17, weight: .bold)
                                        }
                                    )
                                    .padding(.vertical)
                            }
                        }
                    }
                }.background(Color.white)
            }.background(Color.lightestGray)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

fileprivate struct OrderItemsView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Your order")
                    .myFont(size: 17, weight: .medium)
                Spacer()
                Text("See the menu")
                    .myFont(size: 13, weight: .medium, color: .gray)
            }
            ForEach(BasketItem.sampleBasketItems, id: \.menuItem.name) { basketItem in
                HStack(spacing: 16) {
                    Text("\(basketItem.quantity)x")
                        .myFont(size: 15)
                        .frame(width: 26, alignment: .trailing)
                    Text(basketItem.menuItem.name)
                        .myFont(size: 15)
                    Spacer()
                    Text(basketItem.menuItem.price)
                        .myFont(size: 15)
                }
            }
        }
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
    }
}
