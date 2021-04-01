//
//  RestaurantMenuViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import Foundation
import Combine

final class RestaurantMenuViewModel: NSObject, ObservableObject {
    let restaurant: Restaurant
    @Published var menu: Loadable<Menu>
    @Published var basket: Basket
    @Published var currentOrderType = OrderType.pickup
    @Published var showingExistingBasketAlert = false
    var pendingMenuItemIncrement: MenuItem? = nil
    
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
        _basket = .init(wrappedValue: container.appState[\.basket])
        super.init()
        container.appState.updates(for: \.basket)
            .assign(to: \.basket, on: self)
            .store(in: anyCancellableBag)
    }
    
    func loadMenu() {
        container.services.restaurantsService
            .load(menu: loadableBinding(\.menu), restaurantId: restaurant.id)
    }
    
    func incrementBasketQuantityOfMenuItem(_ menuItem: MenuItem) {
        if basket.restaurant == restaurant || basket.items.isEmpty {
            container.appState.bulkUpdate {
                $0.basket.incrementQuantityOfMenuItem(menuItem)
                $0.basket.restaurant = restaurant
            }
        } else {
            pendingMenuItemIncrement = menuItem
            showingExistingBasketAlert = true
        }
    }
    
    func decrementBasketQuantityOfMenuItem(_ menuItem:  MenuItem) {
        container.appState[\.basket].decrementQuantityOfMenuItem(menuItem)
    }
    
    func onExistingBasketAlertAccepted() {
        container.appState.bulkUpdate {
            $0.basket.removeAllItems()
            $0.basket.restaurant = restaurant
            if let pendingMenuItemIncrement = pendingMenuItemIncrement {
                $0.basket.incrementQuantityOfMenuItem(pendingMenuItemIncrement)
            }
        }
        pendingMenuItemIncrement = nil
        showingExistingBasketAlert = false
    }
    
    func onExistingBasketAlertCanceled() {
        pendingMenuItemIncrement = nil
        showingExistingBasketAlert = false
    }
}
