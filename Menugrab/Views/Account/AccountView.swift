//
//  AccountView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(title: "Account", type: .default, onDismiss: { presentationMode.wrappedValue.dismiss() })
                .background(Color.white)
                .padding(.bottom, Constants.formBigSpacing)
            AccountItemView(mainImageSystemName: "folder", actionImageSystemName: "chevron.right", text: "Orders")
                .padding(.bottom, Constants.formSmallSpacing)
            NavigationLink(destination: AccountDetailsFormView()) {
                AccountItemView(mainImageSystemName: "person.crop.square.fill.and.at.rectangle", actionImageSystemName: "chevron.right", text: "Profile")
            }
            .padding(.bottom, Constants.formBigSpacing)
            AccountItemView(mainImageSystemName: nil, actionImageSystemName: "chevron.right", text: "About")
                .padding(.bottom, Constants.formBigSpacing)
            AccountItemView(mainImageSystemName: nil, actionImageSystemName: nil, text: "Log out")
                .padding(.bottom, Constants.formBigSpacing)
            Spacer()
        }
        .background(Color.backgroundGray)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

fileprivate struct AccountItemView: View {
    let mainImageSystemName: String?
    let actionImageSystemName: String?
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            if let imageSystemName = mainImageSystemName {
                Image(systemName: imageSystemName)
                    .font(.system(size: 20))
                    .foregroundColor(.myBlack)
            }
            Text(text)
                .myFont(size: 15, weight: .medium)
            Spacer()
            if let secondaryImageSystemName = actionImageSystemName {
                Image(systemName: secondaryImageSystemName)
                    .font(.system(size: 20))
                    .foregroundColor(.myPrimary)
            }
        }
        .padding()
        .background(Color.white)
        .buttonStyle(PlainButtonStyle())
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
