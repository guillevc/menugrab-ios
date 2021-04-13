//
//  ContentViewModel.swift
//  MenugrabAppClip
//
//  Created by Guillermo Alfonso Varela Chouciño on 08/04/2021.
//

import Foundation
import Combine
import AppClip
import CoreLocation

final class ContentViewModel: NSObject, ObservableObject {
    @Published var user: Loadable<User>
    @Published var restaurant: Loadable<Restaurant>
    @Published var inRegion = false
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    var currentUserUpdate: AnyPublisher<User?, Never> {
        container.appState.updates(for: \.currentUser)
    }
    
    init(
        container: DIContainer,
        user: Loadable<User> = .notRequested,
        restaurant: Loadable<Restaurant> = .notRequested
    ) {
        self.container = container
        _user = .init(wrappedValue: user)
        _restaurant = .init(wrappedValue: restaurant)
    }
    
    func signInAnonymously() {
        container.services.usersService
            .signInAnonymously(user: loadableBinding(\.user))
    }
    
    func handleUserActivity(_ userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL,
              let components = URLComponents(
                url: incomingURL,
                resolvingAgainstBaseURL: true
              ),
              let firstIndexOfRestaurantId = components.path.range(of: "/app-clips/restaurants/")?.upperBound else {
            return
        }
        
        let restaurantId = components.path.suffix(from: firstIndexOfRestaurantId)
        guard let payload = userActivity.appClipActivationPayload else { return }
        
//        let restaurantId = "0hvk480X17rautiZxhbd"
        loadRestaurantAndCheckIfUserInRegion(restaurantId: String(restaurantId), payload: payload)
    }
    
    private func loadRestaurantAndCheckIfUserInRegion(restaurantId: String, payload: APActivationPayload) {
        if EnvironmentVariables.CHECK_USER_LOCATION_DISABLED {
            inRegion = true
        } else {
            _restaurant.projectedValue.sink(
                receiveCompletion: { subscriptionCompletion in
                    if case let .failure(error) = subscriptionCompletion {
                        // TODO: handle error
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] restaurant in
                    guard let self = self,
                          let restaurant = restaurant.value else {
                        return
                    }
                    self.checkIfUserInRestaurantRegion(restaurant: restaurant, payload: payload)
                }
            )
            .store(in: anyCancellableBag)
        }
        
        container.services.restaurantsService
            .load(restaurant: loadableBinding(\.restaurant), id: restaurantId)
    }
    
    private func checkIfUserInRestaurantRegion(restaurant: Restaurant, payload: APActivationPayload) {
        let restaurantRegion = CLCircularRegion(
            center: restaurant.coordinates.locationCoordinate2D,
            radius: 120,
            identifier: "restaurant_location"
        )
        payload.confirmAcquired(in: restaurantRegion) { inRegion, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("inRegion=\(inRegion)")
            DispatchQueue.main.async {
                self.inRegion = inRegion
            }
        }
    }
    
}
