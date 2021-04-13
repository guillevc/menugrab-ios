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
            switch viewModel.restaurant {
            case .notRequested:
                Text("notRequested")
            case .isLoading:
                Text("isLoading")
            case let .loaded(restaurant):
                switch viewModel.user {
                case .notRequested:
                    Text("notRequested")
                case .isLoading:
                    Text("isLoading")
                case .loaded:
                    if viewModel.inRegion {
                        RestaurantMenuView(
                            viewModel: .init(
                                container: viewModel.container,
                                restaurant: restaurant
                            ),
                            navigateToCompletedOrderAction: { newOrder in
                                print("new")
                            }
                        )
                    } else {
                        Text("error: User not in region")
                    }
                case let .failed(error):
                    Text("failed:\(error.localizedDescription)")
                }
            case let .failed(error):
                Text("failed:\(error.localizedDescription)")
            }
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: viewModel.handleUserActivity)
        .onAppear {
            viewModel.signInAnonymously()
        }
        .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil }
    }
}
