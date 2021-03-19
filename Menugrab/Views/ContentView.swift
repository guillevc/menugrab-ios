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
    
    var body: some View {
        ZStack { () -> AnyView in
            if isUserAuthenticated {
                return HomeView(viewModel: HomeViewModel(container: viewModel.container))
                    .eraseToAnyView()
            } else {
                return AuthenticationView(viewModel: AuthenticationViewModel(container: viewModel.container))
                    .eraseToAnyView()
            }
        }
        .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil }
    }
}
