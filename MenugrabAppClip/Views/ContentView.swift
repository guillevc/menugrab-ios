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
                                print("new")
                            }
                        )
                    } else {
                        SplashScreenView(text: "error: Couldn't confirm user is within the restaurant area. Allow location services (Privacy > Location Services > App Clips and try again.", isTextHidden: !viewModel.initialLoadingFinished)
                    }
                }
            }
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: viewModel.handleUserActivity)
        .onAppear {
            viewModel.signInAnonymously()
        }
        .onReceive(viewModel.currentUserUpdate) { self.isUserAuthenticated = $0 != nil }
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
                    .opacity(isTextHidden ? 0 : 1)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}
