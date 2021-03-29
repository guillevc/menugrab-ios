//
//  AppState.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation

struct AppState: Equatable {
    var currentUser: User?
    var basket: Basket
    
    static var defaultValue: Self {
        Self(currentUser: nil, basket: Basket(orderType: .pickup))
    }
}

#if DEBUG
extension AppState {
    static var preview: Self {
        Self(currentUser: nil, basket: .sampleBasket)
    }
}
#endif
