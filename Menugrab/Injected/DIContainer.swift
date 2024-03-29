//
//  DIContainer.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let services: ServicesContainer
    
    static var defaultValue: Self {
        Self(appState: Store(AppState.defaultValue(orderType: .pickup)), services: .stub)
    }
}

struct ServicesContainer {
    let usersService: UsersService
    let restaurantsService: RestaurantsService
    let ordersService: OrdersService
    let imagesService: ImagesService
    let userPermissionsService: UserPermissionsService
    
    init(usersService: UsersService, restaurantsService: RestaurantsService, ordersService: OrdersService, imagesService: ImagesService, userPermissionsService: UserPermissionsService) {
        self.usersService = usersService
        self.restaurantsService = restaurantsService
        self.ordersService = ordersService
        self.imagesService = imagesService
        self.userPermissionsService = userPermissionsService
    }
    
    static var stub: Self {
        .init(usersService: UsersServiceStub(), restaurantsService: RestaurantsServiceStub(), ordersService: OrdersServiceStub(), imagesService: ImagesServiceStub(), userPermissionsService: UserPermissionsServiceStub())
    }
}

struct WebRepositoriesContainer {
    let usersWebRepository: UsersWebRepository
    let restaurantsWebRepository: RestaurantsWebRepository
    let ordersWebRepository: OrdersWebRepository
    let imagesWebRepository: ImagesWebRepository
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: Store(AppState.preview), services: .stub)
    }
}
#endif
