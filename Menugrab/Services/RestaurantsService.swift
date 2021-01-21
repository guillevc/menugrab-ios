//
//  RestaurantsService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import SwiftUI

protocol RestaurantsService {
    func loadNearby(restaurants: Binding<Loadable<[Restaurant]>>, coordinates: Coordinates?)
    func load(restaurant: Binding<Loadable<Restaurant>>, id: String)
    func load(menu: Binding<Loadable<Menu>>, restaurantId: String)
}

struct RestaurantsServiceImpl: RestaurantsService {
    let appState: Store<AppState>
    let webRepository: RestaurantsWebRepository
    
    init(appState: Store<AppState>, webRepository: RestaurantsWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func loadNearby(restaurants: Binding<Loadable<[Restaurant]>>, coordinates: Coordinates?) {
        let anyCancellableBag = AnyCancellableBag()
        
        restaurants.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadNearbyRestaurants(latitude: coordinates?.latitude, longitude: coordinates?.longitude)
            .sinkToLoadable({ restaurants.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
    
    func load(restaurant: Binding<Loadable<Restaurant>>, id: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        restaurant.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadRestaurant(id: id)
            .sinkToLoadable({ restaurant.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
    
    func load(menu: Binding<Loadable<Menu>>, restaurantId: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        menu.wrappedValue.setIsLoading(bag: anyCancellableBag)
        
        webRepository.loadMenu(resturantId: restaurantId)
            .sinkToLoadable({ menu.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
}

struct RestaurantsServiceStub: RestaurantsService {
    func loadNearby(restaurants: Binding<Loadable<[Restaurant]>>, coordinates: Coordinates?) { }
    func load(restaurant: Binding<Loadable<Restaurant>>, id: String) { }
    func load(menu: Binding<Loadable<Menu>>, restaurantId: String) { }
}
