//
//  OrderDetailView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let order: Order
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Order details", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
            Spacer()
        }
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(order: Order.sampleOrders.first!)
    }
}
