//
//  HomeViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 18/01/2021.
//

import Foundation
import Combine

//private var restaurants: [Restaurant] {
//    if let appliedFilter = viewModel.appliedFilter {
//        return Self.allRestaurants.filter({ $0.acceptingOrderTypes.contains(appliedFilter) })
//    } else {
//        return Self.allRestaurants
//    }
//}

final class HomeViewModel: ObservableObject {
    @Published var nearbyRestaurants: Loadable<[Restaurant]>
    @Published var appliedFilter: OrderType? {
        didSet {
            print("TODO")
        }
    }
    @Published var basketIsValid = false
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        nearbyRestaurants: Loadable<[Restaurant]> = .notRequested
    ) {
        self.container = container
        _nearbyRestaurants = .init(wrappedValue: nearbyRestaurants)
        container.appState.updates(for: \.basket.isValid)
            .sink { [weak self] basketIsValid in
                guard let self = self else { return }
                self.basketIsValid = basketIsValid
            }
            .store(in: anyCancellableBag)
        container.appState.updates(for: \.location)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loadNearbyRestaurants()
            }
            .store(in: anyCancellableBag)
    }
    
    func resolveLocationPermissionStatus() {
        container.services.userPermissionsService.resolveStatus(for: .location)
    }
    
    func requestLocationPermission() {
        container.services.userPermissionsService.request(permission: .location)
    }
    
    func loadNearbyRestaurants() {
        var coordinates: Coordinates?
        
        if let clLocationCoordinate2D = container.appState[\.location]?.coordinate {
            coordinates = Coordinates(clLocationCoordinate2D: clLocationCoordinate2D)
        }
        
        container.services.restaurantsService
            .loadNearby(restaurants: loadableBinding(\.nearbyRestaurants), coordinates: coordinates)
    }
    
}
