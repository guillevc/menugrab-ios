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
    @State private var currentOrder: Order? = nil
    
    var body: some View {
        VStack {
            if let currentOrder = currentOrder {
                Text("Current order \(currentOrder.id) from \(currentOrder.restaurant.name)")
            } else {
                Text("Current order empty")
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
        .onReceive(viewModel.currentOrderUpdate) { self.currentOrder = $0 }
        
    }
}
