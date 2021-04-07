//
//  AuthenticationView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import SwiftUI

enum AuthenticationViewStep {
    case selection
    case create
    case signIn
}

struct AuthenticationView: View {
    private static let formHorizontalPadding: CGFloat = 60
    
    @ObservedObject var viewModel: AuthenticationViewModel
    @State var currentStep: AuthenticationViewStep = .selection
    
    var topPadding: CGFloat {
        switch currentStep {
        case .selection:
            return 250
        case .create, .signIn:
            return 200
        }
    }
    
    var bottomPadding: CGFloat {
        switch currentStep {
        case .selection:
            return 100
        case .create, .signIn:
            return 120
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("menu")
                Text("grab")
                    .foregroundColor(.myPrimary)
            }
            .myFont(size: 32, weight: .bold)
            .padding(.top, topPadding)
            Spacer()
            if currentStep == .selection {
                VStack(spacing: 12) {
                    Button(action: { withAnimation { currentStep = .signIn } }) {
                        secondaryButtonView
                    }
                    .buttonStyle(IdentityButtonStyle())
                    Button(action: { withAnimation { currentStep = .create } }) {
                        primaryButtonView(text: "Sign up")
                    }
                    .buttonStyle(IdentityButtonStyle())
                    Button(action: { viewModel.signInAnonymously() }) {
                        HStack {
                            Text("Continue as guest")
                                .myFont(size: 13, weight: .medium, color: .gray)
                            Image(systemName: "chevron.forward.2")
                                .font(Font.system(size: 9, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.bottom, bottomPadding)
            } else {
                switch viewModel.user {
                case .notRequested, .isLoading:
                    VStack(spacing: 16) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .myFont(size: 17)
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .myFont(size: 17)
                        if currentStep == .create {
                            Button(action: { viewModel.create() }) {
                                primaryButtonView(text: "Sign up")
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            Button(action: { viewModel.signIn() }) {
                                primaryButtonView(text: "Log in")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        VStack(spacing: 4) {
                            if currentStep == .create {
                                Button(action: { withAnimation { currentStep = .signIn } }) {
                                    HStack(spacing: 0) {
                                        Text("Do you have an account already? ")
                                            .myFont(size: 13, color: .lightGray)
                                        Text("Log in!")
                                            .myFont(size: 13, weight: .bold, color: .lightGray)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                Button(action: { withAnimation { currentStep = .create } }) {
                                    Text("Create a new account")
                                        .myFont(size: 13, weight: .bold, color: .lightGray)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Text("- or -")
                                .myFont(size: 13, weight: .medium, color: .lightGray)
                            HStack {
                                Button(action: { }) {
                                    Text("Continue as guest")
                                        .myFont(size: 13, weight: .bold, color: .lightGray)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, bottomPadding)
                    .animation(.none)
                case .loaded:
                    if let email = viewModel.user.value?.email {
                        Text("Logged in as \(email)")
                    } else {
                        Text("Logged in with nil email")
                    }
                case let .failed(error):
                    VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: { viewModel.user = Loadable.notRequested })
                            .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                }
            }
        }
        .padding(.horizontal, Self.formHorizontalPadding)
    }
    
    private var secondaryButtonView: some View {
        Text("Log in")
            .myFont(size: 17, weight: .medium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                    .strokeBorder(Color.myPrimaryLighter, lineWidth: 1)
                    .background(
                        Color.myPrimaryLighter.cornerRadius(.greatestFiniteMagnitude)
                    )
            )
    }
    
    private func primaryButtonView(text: String) -> some View {
        Text(text)
            .myFont(size: 17, weight: .bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                    .strokeBorder(Color.myPrimary, lineWidth: 1)
                    .background(
                        Color.myPrimary.cornerRadius(.greatestFiniteMagnitude)
                    )
            )
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel(container: .preview))
    }
}
