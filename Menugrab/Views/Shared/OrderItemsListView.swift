//
//  OrderItemsListView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/04/2021.
//

import SwiftUI

struct OrderItemView: View {
    private static let quantityFrameWidth: CGFloat = 26
    let orderItems: [OrderItem]
    
    var body: some View {
        ForEach(orderItems, id: \.menuItem.name) { basketItem in
            HStack(spacing: 16) {
                Text("\(basketItem.quantity)x")
                    .myFont(size: 15)
                    .frame(width: Self.quantityFrameWidth, alignment: .trailing)
                Text(basketItem.menuItem.name)
                    .myFont(size: 15)
                Spacer()
                Text("\(basketItem.totalPrice.formattedAmount ?? "-") €")
                    .myFont(size: 15)
            }
        }
    }
}

struct OrderItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OrderItemView(orderItems: Order.sampleOrderItems)
        }
    }
}
