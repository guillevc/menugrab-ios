//
//  RestaurantsService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import SwiftUI

protocol RestaurantsService {
    func loadNearby(restaurants: Binding<Loadable<[RestaurantDTO]>>)
    func load(restaurant: Binding<Loadable<RestaurantDTO>>, id: String)
}

struct RestaurantsServiceImpl: RestaurantsService {
    let appState: Store<AppState>
    let webRepository: RestaurantsWebRepository
    
    init(appState: Store<AppState>, webRepository: RestaurantsWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func loadNearby(restaurants: Binding<Loadable<[RestaurantDTO]>>) {
        let anyCancellableBag = AnyCancellableBag()
        
        restaurants.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadNearbyRestaurants()
            .sinkToLoadable({ restaurants.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
    
    func load(restaurant: Binding<Loadable<RestaurantDTO>>, id: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        restaurant.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadRestaurant(id: id)
            .sinkToLoadable({ restaurant.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
    
}

struct RestaurantsServiceStub: RestaurantsService {
    func loadNearby(restaurants: Binding<Loadable<[RestaurantDTO]>>) { }
    func load(restaurant: Binding<Loadable<RestaurantDTO>>, id: String) { }
}
