//
//  RestaurantMenuViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import Foundation

final class RestaurantMenuViewModel: NSObject, ObservableObject {
    var restaurant: Restaurant? = nil
    @Published var menu: Loadable<Menu> = .notRequested
    @Published var basket: Basket = Basket.sampleBasket
    
    var container: DIContainer? = nil
    private var anyCancellableBag = AnyCancellableBag()
    
    func setup(container: DIContainer, restaurant: Restaurant, menu: Loadable<Menu> = .notRequested) {
        self.container = container
        self.restaurant = restaurant
        _menu = .init(wrappedValue: menu)
    }
    
    func loadMenu() {
        guard let restaurantsService = container?.services.restaurantsService, let restaurantId = restaurant?.id else { return }
        restaurantsService
            .load(menu: loadableBinding(\.menu), restaurantId: restaurantId)
    }
}

#if DEBUG
extension RestaurantMenuViewModel {
    static var preview: Self {
        let viewModel = Self.init()
        viewModel.setup(container: .preview, restaurant: Restaurant.sampleRestaurants.first!, menu: Loadable.loaded(Menu.sampleMenu))
        return viewModel
    }
}
#endif
