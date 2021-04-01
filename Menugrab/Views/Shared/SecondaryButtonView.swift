//
//  SecondaryButtonView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import SwiftUI

enum SecondaryButtonViewSize {
    case big
    case medium
}

struct SecondaryButtonView<Icon: View>: View {
    let text: String
    let size: SecondaryButtonViewSize
    let icon: Icon
    
    var textSize: CGFloat {
        switch size {
        case .big:
            return 15
        case .medium:
            return 13
        }
    }
    
    init(text: String, size: SecondaryButtonViewSize = .big, @ViewBuilder icon: @escaping () -> Icon) {
        self.text = text
        self.size = size
        self.icon = icon()
    }
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(.myPrimary)
            Text(text)
                .myFont(size: textSize, weight: .medium, color: .myPrimary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.myPrimaryLighter.cornerRadius(20))
    }
}

struct SecondaryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButtonView(text: "Add more items") {
            Image(systemName: "plus")
                .font(.system(size: 17))
        }
    }
}
