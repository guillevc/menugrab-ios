//
//  OrdersViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/03/2021.
//

import Foundation

final class OrdersViewModel: NSObject, ObservableObject {
    @Published var orders: Loadable<[Order]>
    
    var inProgressOrders: [Order] {
        orders.value?.filter({ $0.isInProgress }) ?? []
    }
    
    var completedOrders: [Order] {
        orders.value?.filter({ !$0.isInProgress }) ?? []
    }
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        orders: Loadable<[Order]> = .notRequested
    ) {
        self.container = container
        _orders = .init(wrappedValue: orders)
    }
    
    func loadUserOrders() {
        guard let userId = container.appState.value.currentUser?.uid else { return }
        
        container.services.ordersService
            .loadByUserId(orders: loadableBinding(\.orders), userId: userId)
    }
}
