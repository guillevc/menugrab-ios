//
//  RestaurantDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct RestaurantDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let restaurant: Restaurant
    
    @State var isHeaderVisible = false
    
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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        GeometryReader { geometry in
                            ZStack(alignment: .top) {
                                restaurant.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: heightForHeaderImage(geometry))
                                    .clipped()
                                    .offset(x: 0, y: offsetForHeaderImage(geometry))
                                    .brightness(-0.08)
                            }
                        }.frame(height: 200)
                        Text("hi").frame(height: 300)
                        Text("hi").frame(height: 300)
                        Text("hi").frame(height: 300)
                    }
                }
                ZStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    Spacer()
                    Text("Restaurant name")
                        .myFont(size: 17, weight: .medium, color: .blue)
                        .opacity(isHeaderVisible ? 1 : 0)
                    Spacer()
                }
                .padding()
                .frame(height: 54)
                .background(Color.red.opacity(isHeaderVisible ? 1 : 0))
                .offset(x: 0, y: geometry.safeAreaInsets.top)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant.sampleRestaurants().first!)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
