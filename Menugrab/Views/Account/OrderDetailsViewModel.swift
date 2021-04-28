//
//  OrderDetailsViewModel.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 07/04/2021.
//

import Foundation

final class OrderDetailsViewModel: NSObject, ObservableObject {
    let type: OrderDetailsViewType
    
    @Published var order: Order
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        type: OrderDetailsViewType
    ) {
        self.container = container
        self.type = type
        
        switch type {
        case let .completedOrder(order):
            self.order = order
            super.init()
        case .currentOrder:
            // TODO: detail crashes when order is completed (set to nil)
            self.order = container.appState[\.currentOrder]!
            super.init()
            container.appState.updates(for: \.currentOrder)
                .sink { [weak self] currentOrder in
                    guard let self = self else { return }
                    self.order = currentOrder!
                }
                .store(in: anyCancellableBag)
        }
    }
}
