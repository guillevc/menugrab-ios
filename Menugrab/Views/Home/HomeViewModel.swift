//
//  HomeViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 18/01/2021.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published private var nearbyRestaurants: Loadable<[Restaurant]>
    @Published var currentOrder: Order?
    @Published var appliedFilter: OrderType?
    @Published var basketIsValid = false
    
    var filteredNearbyRestaurants: Loadable<[Restaurant]> {
        if case let .loaded(restaurants) = nearbyRestaurants,
           let appliedFilter = appliedFilter {
            let filtered = restaurants.filter {
                $0.acceptingOrderTypes.contains(appliedFilter)
            }
            return .loaded(filtered)
        } else {
            return nearbyRestaurants
        }
    }

    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        nearbyRestaurants: Loadable<[Restaurant]> = .notRequested
    ) {
        self.container = container
        _nearbyRestaurants = .init(wrappedValue: nearbyRestaurants)
        container.appState.updates(for: \.currentOrder)
            .sink { [weak self] currentOrder in
                guard let self = self else { return }
                self.currentOrder = currentOrder
            }
            .store(in: anyCancellableBag)
        container.appState.updates(for: \.basket.isValid)
            .sink { [weak self] basketIsValid in
                guard let self = self else { return }
                self.basketIsValid = basketIsValid
            }
            .store(in: anyCancellableBag)
        container.appState.updates(for: \.location)
            .sink { [weak self] location in
                guard let self = self else { return }
                var coordinates: Coordinates?
                if let clLocationCoordinate2D = location?.coordinate {
                    coordinates = Coordinates(clLocationCoordinate2D: clLocationCoordinate2D)
                }
                self.loadNearbyRestaurants(coordinates: coordinates)
            }
            .store(in: anyCancellableBag)
    }
    
    func resolveLocationPermissionStatus() {
        container.services.userPermissionsService.resolveStatus(for: .location)
    }
    
    func requestLocationPermission() {
        container.services.userPermissionsService.request(permission: .location)
    }
    
    private func loadNearbyRestaurants(coordinates: Coordinates?) {
        container.services.restaurantsService
            .loadNearby(restaurants: loadableBinding(\.nearbyRestaurants), coordinates: coordinates)
    }
}
