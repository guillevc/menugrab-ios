//
//  BasketView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 30/12/2020.
//

import SwiftUI

struct BasketView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.myBlack)
                    }
                    Spacer()
                }
                Spacer()
                Text("Your basket")
                    .myFont(size: 17, weight: .medium)
                Spacer()
            }
            .padding()
            .frame(height: 54)
            Spacer()
        }
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView()
    }
}
