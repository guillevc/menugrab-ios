//
//  OrderItemsTotalPriceView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 05/04/2021.
//

import SwiftUI

struct OrderItemsTotalPriceView: View {
    let totalPrice: Decimal
    var quantityFrameWidth: CGFloat = 26
    
    var body: some View {
        HStack(spacing: 16) {
            Spacer().frame(width: quantityFrameWidth)
            Text("Total")
            Spacer()
            Text("\(totalPrice.formattedAmount ?? "-") €")
        }
        .myFont(size: 17, weight: .medium)
    }
}

struct OrderItemsTotalPriceView_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemsTotalPriceView(totalPrice: 99.99)
    }
}
