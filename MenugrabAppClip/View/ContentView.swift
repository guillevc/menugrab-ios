//
//  ContentView.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State var isUserAuthenticated = false
    
    var body: some View {
        Group {
            switch viewModel.user {
            case .notRequested:
                Text("notRequested")
            case .isLoading:
                Text("isLoading")
            case .loaded:
                RestaurantMenuView(
                    viewModel: .init(
                        container: viewModel.container,
                        restaurant: Restaurant.sampleRestaurants.first!
                    ),
                    navigateToCompletedOrderAction: { newOrder in
                        print("new")
                    }
                )
            case let .failed(error):
                Text("failed:\(error.localizedDescription)")
            }
        }
        .onAppear {
            viewModel.container.services.userPermissionsService.request(permission: .location)
            viewModel.signInAnonymously()
        }
        .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil }
    }
}
