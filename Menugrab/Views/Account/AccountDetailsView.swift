//
//  AccountDetailsView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct AccountDetailsFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(type: .default, title: "Account details", onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
                .padding(.bottom, Constants.formBigSpacing)
            FormInputView()
            Spacer()
        }
        .background(Color.backgroundGray)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

fileprivate struct FormInputView: View {
    var body: some View {
        Text("hi")
    }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsFormView()
    }
}
