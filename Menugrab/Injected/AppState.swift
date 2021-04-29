//
//  AppState.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation
import CoreLocation

struct AppState: Equatable {
    var currentUser: User?
    var currentOrder: Order?
    var location: CLLocation?
    var basket: Basket
    var permissions = Permissions()
    var displayedErrorMessage: String?
    
    static func defaultValue(orderType: OrderType) -> Self {
        Self(currentUser: nil, currentOrder: nil, basket: Basket(orderType: orderType))
    }
}

// MARK: - Permissions

extension AppState {
    struct Permissions: Equatable {
        var location: Permission.Status = .unknown
    }
    
    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .location:
            return pathToPermissions.appending(path: \.location)
        }
    }
}

#if DEBUG
extension AppState {
    static var preview: Self {
        Self(currentUser: nil, currentOrder: Order.sampleOrders.first!, basket: .sampleBasket)
    }
}
#endif
