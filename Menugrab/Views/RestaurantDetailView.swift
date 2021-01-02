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
    
    private func updateNavbarVisibility(imageGeometry: GeometryProxy, topGeometry: GeometryProxy) {
        if -scrollOffset(imageGeometry) >= (imageGeometry
            .size.height + topGeometry.safeAreaInsets.top) {
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
                    VStack {
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
                        }.frame(height: 200)
                        Text("hi").frame(height: 300).background(Color.green)
                        Text("hi").frame(height: 300).background(Color.orange)
                        Text("hi").frame(height: 300).background(Color.yellow)
                    }
                }
                ZStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(isHeaderVisible ? .black : .blue)
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
                .offset(x: 0, y: topGeometry.safeAreaInsets.top)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant.sampleRestaurants.first!)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
