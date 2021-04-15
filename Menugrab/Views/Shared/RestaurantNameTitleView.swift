//
//  RestaurantNameTitleView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/04/2021.
//

import SwiftUI

struct RestaurantNameTitleView: View {
    let restaurantName: String
    let showChevronRight: Bool
    
    init(restaurantName: String, showChevronRight: Bool = true) {
        self.restaurantName = restaurantName
        self.showChevronRight = showChevronRight
    }

    var body: some View {
        HStack {
            Text(restaurantName)
                .myFont(size: 23, weight: .bold, color: .black)
                .background(
                    VStack {
                        Spacer()
                        Color.myPrimaryLighter
                            .frame(height: 5)
                            .offset(x: 0, y: -7)
                    }
                )
            if showChevronRight {
                Image(systemName: "chevron.right")
                    .font(.system(size: 17))
                    .foregroundColor(.myPrimary)
            }
        }
    }
}

struct RestaurantNameTitleView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantNameTitleView(restaurantName: "Restaurant name")
    }
}
