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
    let imagesService: ImagesService
    let usersService: UsersService
    
    init(restaurantsService: RestaurantsService, imagesService: ImagesService, usersService: UsersService) {
        self.restaurantsService = restaurantsService
        self.imagesService = imagesService
        self.usersService = usersService
    }
    
    static var stub: Self {
        .init(restaurantsService: RestaurantsServiceStub(), imagesService: ImagesServiceStub(), usersService: UsersServiceStub())
    }
}

struct WebRepositoriesContainer {
    let restaurantsWebRepository: RestaurantsWebRepository
    let imagesWebRepository: ImagesWebRepository
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(services: .stub)
    }
}
#endif
