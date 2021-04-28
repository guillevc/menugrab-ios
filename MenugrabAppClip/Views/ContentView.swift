//
//  ContentView.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import SwiftUI

fileprivate enum FullScreenCoverItem: Identifiable {
    case orderDetails(order: Order)
    
    var id: String {
        switch self {
        case let .orderDetails(order):
            return "orderDetails[\(order.id)]"
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var isUserAuthenticated = false
    @State private var activeFullScreenCover: FullScreenCoverItem? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.user {
                case .notRequested, .isLoading:
                    SplashScreenView(text: "Creating anonymous user session...", isTextHidden: !viewModel.initialLoadingFinished)
                case let .failed(error):
                    SplashScreenView(text: "error: Couldn't create anonymous user session. (\(error.localizedDescription))", isTextHidden: !viewModel.initialLoadingFinished)
                case .loaded:
                    switch viewModel.restaurant {
                    case .notRequested, .isLoading:
                        SplashScreenView(text: "Loading restaurant data...", isTextHidden: !viewModel.initialLoadingFinished)
                    case let .failed(error):
                        SplashScreenView(text: "error: Couldn't load restaurant data. (\(error.localizedDescription))", isTextHidden: !viewModel.initialLoadingFinished)
                    case let .loaded(restaurant):
                        if viewModel.inRegion {
                            RestaurantMenuView(
                                viewModel: .init(
                                    container: viewModel.container,
                                    restaurant: restaurant
                                ),
                                navigateToCompletedOrderAction: { newOrder in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        activeFullScreenCover = .orderDetails(order: newOrder)
                                    }
                                }
                            )
                        } else {
                            SplashScreenView(text: "error: Couldn't confirm user is within the restaurant area. \nAllow location services (Settings > Privacy > Location Services > App Clips) and try again.", isTextHidden: !viewModel.initialLoadingFinished)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: viewModel.handleUserActivity)
            .onAppear {
                viewModel.signInAnonymously()
            }
            .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil } 
        }
        .fullScreenCover(item: $activeFullScreenCover) { item in
            switch item {
            case let .orderDetails(createdOrder):
                OrderDetailsView(
                    viewModel: .init(container: viewModel.container, type: .completedOrder(createdOrder)),
                    presentationType: .notNavigable,
                    navigateToRestaurantAction: { _ in },
                    navigateToCompletedOrderAction: nil
                )
            }
        }
    }
}

fileprivate struct SplashScreenView: View {
    let text: String
    let isTextHidden: Bool
    
    var body: some View {
        ZStack {
            MenugrabLogoView()
            VStack {
                Spacer()
                Text(text)
                    .myFont()
                    .opacity(isTextHidden ? 0 : 1)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}
