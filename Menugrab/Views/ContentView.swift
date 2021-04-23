//
//  ContentView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 11/03/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var isUserAuthenticated = false
    @State private var displayedErrorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            if let displayedErrorMessage = displayedErrorMessage {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.myBlack)
                    Text(displayedErrorMessage)
                        .myFont(size: 13, color: .myBlack)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color.errorRed)
            }
            ZStack { () -> AnyView in
                if isUserAuthenticated {
                    return HomeView(viewModel: HomeViewModel(container: viewModel.container))
                        .eraseToAnyView()
                } else {
                    return AuthenticationView(viewModel: AuthenticationViewModel(container: viewModel.container))
                        .eraseToAnyView()
                }
            }
        }
        .onAppear {
            viewModel.container.services.userPermissionsService.request(permission: .location)
        }
        .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil }
        .onReceive(viewModel.displayedErrorMessagesUpdate) { newErrorMessage in
            withAnimation {
                displayedErrorMessage = newErrorMessage
                if newErrorMessage != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                        viewModel.container.appState[\.displayedErrorMessage] = nil
                        displayedErrorMessage = nil
                    }
                }
            }
        }
    }
}
