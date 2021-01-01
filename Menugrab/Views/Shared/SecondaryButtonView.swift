//
//  SecondaryButtonView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 01/01/2021.
//

import SwiftUI

struct SecondaryButtonView<Icon: View>: View {
    let text: String
    let icon: Icon
    
    init(text: String, @ViewBuilder icon: @escaping () -> Icon) {
        self.text = text
        self.icon = icon()
    }
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(.myPrimary)
            Text(text)
                .myFont(size: 15, weight: .medium, color: .myPrimary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.myPrimaryLight.cornerRadius(20))
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
