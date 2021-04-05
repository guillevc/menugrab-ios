//
//  BasketViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 26/03/2021.
//

import Foundation

final class BasketViewModel: NSObject, ObservableObject {
    let container: DIContainer
    let navigateToCompletedOrderAction: (Order) -> ()
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        navigateToCompletedOrderAction: @escaping (Order) -> ()
    ) {
        self.container = container
        self.navigateToCompletedOrderAction = navigateToCompletedOrderAction
    }
    
    func createOrderFromCurrentBasket() {
        let basket = container.appState[\.basket]
        container.services.ordersService.createOrder(from: basket)?
            .sink(receiveCompletion: { subscriptionCompletion in
                if case let .failure(error) = subscriptionCompletion {
                    // TODO: handle order error
                    print(error.localizedDescription)
                }
            }, receiveValue: { order in
                self.container.appState[\.basket].removeAllItems()
                self.navigateToCompletedOrderAction(order)
            })
            .store(in: anyCancellableBag)
    }
}
