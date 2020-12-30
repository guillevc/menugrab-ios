//
//  RestaurantSearchInputView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 29/12/2020.
//

import SwiftUI

enum RestaurantSearchInputViewType: Equatable {
    case input
    case display(onSliderTapped: (() -> ())?)
    
    static func == (lhs: RestaurantSearchInputViewType, rhs: RestaurantSearchInputViewType) -> Bool {
        if case .display(_) = lhs {
            if case .display(_) = rhs {
                return true
            }
        }
        if case .input = lhs {
            if case .input = rhs {
                return true
            }
        }
        return false
    }
}

struct RestaurantSearchInputView: View {
    
    let type: RestaurantSearchInputViewType
    
    @State var keywords = ""
    
    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        return HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18))
            TextField("Search restaurants", text: $keywords)
                .myFont(size: type == .input ? 17 : 15)
                .padding(.vertical, type == .input ? 7 : 9)
                .disabled(type != .input)
            if case let .display(onSliderTapped: onSliderTapped) = type {
                Button(action: { onSliderTapped?() }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.darkGray)
                        .font(.system(size: 20))
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
        Group {
            RestaurantSearchInputView(type: .display(onSliderTapped: nil))
                .previewDisplayName("Display mode")
            RestaurantSearchInputView(type: .input)
                .previewDisplayName("Input mode")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
