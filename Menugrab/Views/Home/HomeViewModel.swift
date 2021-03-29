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
        container.appState.sink { [weak self] appState in
            guard let self = self else { return }
            self.basketIsValid = appState.basket.isValid
        }
        .store(in: anyCancellableBag)
    }
    
    func loadNearbyRestaurants() {
        // TODO: user coordinates
        container.services.restaurantsService
            .loadNearby(restaurants: loadableBinding(\.nearbyRestaurants), coordinates: .init(latitude: 43.3728824, longitude: -8.4064193))
    }
}
