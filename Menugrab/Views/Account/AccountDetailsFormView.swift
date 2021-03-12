//
//  AccountDetailsView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import SwiftUI

struct AccountDetailsFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var viewModel: AccountDetailsFormViewModel
   
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBarView(
                title: "My profile",
                type: .default,
                onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                },
                rightButtonType: .save,
                onRightButtonTapped: {
                    viewModel.updateUser()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .background(Color.white)
            .padding(.bottom, Constants.formBigSpacing)
            FormFieldView(type: .name, value: $viewModel.name)
                .padding(.bottom, Constants.formSmallSpacing)
            FormFieldView(type: .email, value: $viewModel.email)
                .padding(.bottom, Constants.formBigSpacing)
            FormFieldView(type: .newPassword, value: $viewModel.newPassword)
                .padding(.bottom, Constants.formSmallSpacing)
            FormFieldView(type: .newPasswordRepeat, value: $viewModel.newPasswordRepeat)
            Spacer()
        }
        .background(Color.backgroundGray)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

enum FormFieldViewType: String {
    case name
    case email
    case newPassword
    case newPasswordRepeat
    
    var label: String {
        switch self {
        case .name:
            return "Name"
        case .email:
            return "Email"
        case .newPassword:
            return "New password"
        case .newPasswordRepeat:
            return "Repeat new password"
        }
    }
    
    var contentType: UITextContentType? {
        switch self {
        case .name:
            return .username
        case .email:
            return .emailAddress
        case .newPassword, .newPasswordRepeat:
            return .newPassword
        }
    }
    
    var isSecureField: Bool {
        switch self {
        case .newPassword, .newPasswordRepeat:
            return true
        default:
            return false
        }
    }
}

fileprivate struct FormFieldView: View {
    let type: FormFieldViewType
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type.label)
                .myFont(size: 13, color: Color.gray)
            
            if type.isSecureField {
                SecureField("", text: $value)
                    .myFont(size: 17)
                    .textContentType(type.contentType)
            } else {
                TextField("", text: $value)
                    .myFont(size: 17)
                    .textContentType(type.contentType)
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white)
        
    }
}

struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsFormView(viewModel: .init(container: .preview))
    }
}
