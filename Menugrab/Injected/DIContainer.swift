//
//  DIContainer.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    
    let services: ServicesContainer
    
    static var defaultValue: Self {
        Self(services: .stub)
    }
}

struct ServicesContainer {
    let restaurantsService: RestaurantsService
    
    init(restaurantsService: RestaurantsService) {
        self.restaurantsService = restaurantsService
    }
    
    static var stub: Self {
        .init(restaurantsService: RestaurantsServiceStub())
    }
}

struct WebRepositoriesContainer {
    let restaurantsWebRepository: RestaurantsWebRepository
}
