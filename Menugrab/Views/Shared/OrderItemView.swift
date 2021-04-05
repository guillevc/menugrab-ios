//
//  OrderItemsListView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/04/2021.
//

import SwiftUI

struct OrderItemView: View {
    let orderItem: OrderItem
    var quantityFrameWidth: CGFloat = 26
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(orderItem.quantity)x")
                .myFont(size: 15)
                .frame(width: quantityFrameWidth, alignment: .trailing)
            Text(orderItem.menuItem.name)
                .myFont(size: 15)
            Spacer()
            Text("\(orderItem.totalPrice.formattedAmount ?? "-") €")
                .myFont(size: 15)
        }
    }
}

struct OrderItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemView(orderItem: Order.sampleOrderItems.first!, quantityFrameWidth: 26)
    }
}
