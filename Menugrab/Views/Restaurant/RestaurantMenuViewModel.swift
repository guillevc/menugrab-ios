//
//  RestaurantMenuViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import Foundation

final class RestaurantMenuViewModel: NSObject, ObservableObject {
    let restaurant: Restaurant
    @Published var menu: Loadable<Menu>
    @Published var basket: Basket = Basket.sampleBasket
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        restaurant: Restaurant,
        menu: Loadable<Menu> = .notRequested
    ) {
        self.container = container
        self.restaurant = restaurant
        _menu = .init(wrappedValue: menu)
    }
    
    func loadMenu() {
        container.services.restaurantsService
            .load(menu: loadableBinding(\.menu), restaurantId: restaurant.id)
    }
}
