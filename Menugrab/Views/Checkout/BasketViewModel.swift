//
//  BasketViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 26/03/2021.
//

import Foundation

final class BasketViewModel: NSObject, ObservableObject {
    @Published var orderRequestInProgress = false
    
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
        orderRequestInProgress = true
        container.services.ordersService.createOrderFromBasket()?
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.container.appState[\.displayedErrorMessage] = error.localizedDescription
                }
                self.orderRequestInProgress = false
            }, receiveValue: { order in
                self.navigateToCompletedOrderAction(order)
                self.orderRequestInProgress = false
            })
            .store(in: anyCancellableBag)
    }
}
