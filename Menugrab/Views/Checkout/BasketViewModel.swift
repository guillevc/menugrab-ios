//
//  BasketViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 26/03/2021.
//

import Foundation

final class BasketViewModel: NSObject, ObservableObject {
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    @Published var createdOrder: Loadable<Order>
    
    init(
        container: DIContainer,
        createdOrder: Loadable<Order> = .notRequested
    ) {
        self.container = container
        _createdOrder = .init(wrappedValue: createdOrder)
    }
    
    func createOrderFromCurrentBasket() {
        let basket = container.appState[\.basket]
        container.services.ordersService.create(order: loadableBinding(\.createdOrder), from: basket)
    }
}
