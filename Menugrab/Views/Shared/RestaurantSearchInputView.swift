//
//  RestaurantSearchInputView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/12/2020.
//

import SwiftUI

struct RestaurantSearchInputView: View {
    
    let fontSize: CGFloat
    let textFieldDisabled: Bool
    let showSlider: Bool
    let onSliderTapped: (() -> ())?
    
    @State var keywords = ""
    
    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        return HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search restaurants", text: $keywords)
                    .font(.custom("DM Sans", size: fontSize))
                    .foregroundColor(.myBlack)
                    .padding(.vertical, 6)
                    .disabled(textFieldDisabled)
            if showSlider {
                Button(action: { onSliderTapped?() }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.darkGray)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.lightestGray)
        )
    }
}

struct RestaurantSearchInputView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSearchInputView(fontSize: 17, textFieldDisabled: false, showSlider: true, onSliderTapped: nil)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
