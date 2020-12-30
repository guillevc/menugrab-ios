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
                .font(.custom("DM Sans", size: 23))
                .fontWeight(.bold)
                .foregroundColor(.white)
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
                        if acceptingOrderTypes.contains(.table) {
                            HStack(spacing: 4) {
                                Image("table-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 17.5, height: 17.5, alignment: .center)
                                Text("Table")
                                    .font(.custom("DM Sans", size: 13))
                                    .foregroundColor(.myBlack)
                            }
                        }
                        if acceptingOrderTypes.contains(.pickup) {
                            HStack(spacing: 4) {
                                Image("pickup-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15.5, height: 15.5, alignment: .center)
                                Text("Pickup")
                                    .font(.custom("DM Sans", size: 13))
                                    .foregroundColor(.myBlack)
                            }
                        }
                        Spacer()
                        Text("8 km away")
                            .font(.custom("DM Sans", size: 13))
                            .foregroundColor(.myBlack)
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
            ForEach(Array(Restaurant.sampleRestaurants().enumerated()), id: \.offset) { index, restaurant in
                RestaurantCellView(name: restaurant.name, image: restaurant.image, acceptingOrderTypes: restaurant.acceptingOrderTypes)
                    .padding()
            }.previewLayout(.fixed(width: 320, height: 170))
        }
    }
}
