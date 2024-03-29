//
//  FilterTagView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 02/01/2021.
//

import SwiftUI

struct RestaurantFilterAppliedTagView: View {
    let type: OrderType
    let onRemoveTapped: (() -> ())?
    
    var text: String {
        switch type {
        case .pickup:
            return "Pickup"
        case .table:
            return "Table"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .myFont(size: 15, weight: .regular, color: .myBlack)
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .medium, design: .default))
                .foregroundColor(.myBlack)
                .padding(4)
                .onTapGesture(perform: { onRemoveTapped?() })
        }
        .padding(.vertical, 5)
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .background(
            Color.myPrimaryLight.cornerRadius(8)
        )
    }
}

struct FilterTagView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantFilterAppliedTagView(type: .pickup, onRemoveTapped: nil)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
