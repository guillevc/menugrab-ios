//
//  HomeViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 18/01/2021.
//

import Foundation

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
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        nearbyRestaurants: Loadable<[Restaurant]> = .notRequested
    ) {
        self.container = container
        _nearbyRestaurants = .init(wrappedValue: nearbyRestaurants)
    }
    
    func loadNearbyRestaurants() {
        container.services.restaurantsService
            .loadNearby(restaurants: loadableBinding(\.nearbyRestaurants), coordinates: nil)
    }
}
