//
//  RestaurantCellView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/12/2020.
//

import SwiftUI

struct RestaurantCellView: View {
    let name: String
    let image: Image
    let acceptingOrderTypes: [OrderType]
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, idealWidth: 320, maxWidth: .infinity, minHeight: 0, idealHeight: 160, maxHeight: .infinity, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(name)
                .myFont(size: 23, weight: .bold, color: .white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .shadow(color: .black, radius: 3, x: 0, y: 0)
            VStack {
                Spacer()
                ZStack {
                    Color.white
                        .opacity(0.85)
                        .frame(minWidth: 0, idealWidth: 320, maxWidth: .infinity, minHeight: 28, idealHeight: 28, maxHeight: 28, alignment: .center)
                    HStack(spacing: 14) {
                        ForEach(acceptingOrderTypes, id: \.self) { orderType in
                            HStack(spacing: 4) {
                                orderType.icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 17.5, height: 17.5, alignment: .center)
                                Text(orderType.rawValue)
                                    .myFont(size: 13)
                            }
                        }
                        Spacer()
                        Text("8 km away")
                            .myFont(size: 13)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(minWidth: 0, idealWidth: 320, maxWidth: .infinity, minHeight: 0, idealHeight: 160, maxHeight: .infinity, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.14), radius: 12, x: 0, y: 0)
    }
}

struct RestaurantCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Array(Restaurant.sampleRestaurants.enumerated()), id: \.offset) { index, restaurant in
                RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                    .padding()
            }.previewLayout(.fixed(width: 320, height: 170))
        }
    }
}
