//
//  OrdersService.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/03/2021.
//

import Foundation
import SwiftUI

protocol OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String)
}

struct OrdersServiceImpl: OrdersService {
    let appState: Store<AppState>
    let webRepository: OrdersWebRepository
    
    init(appState: Store<AppState>, webRepository: OrdersWebRepository) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) {
        let anyCancellableBag = AnyCancellableBag()
        
        orders.wrappedValue.setIsLoading(bag: anyCancellableBag)

        webRepository.loadOrdersByUserId(userId: userId)
            .sinkToLoadable({ orders.wrappedValue = $0 })
            .store(in: anyCancellableBag)
    }
}

struct OrdersServiceStub: OrdersService {
    func loadByUserId(orders: Binding<Loadable<[Order]>>, userId: String) { }
}
