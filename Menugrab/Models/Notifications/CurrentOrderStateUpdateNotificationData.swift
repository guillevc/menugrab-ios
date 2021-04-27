//
//  CurrentOrderStateUpdateNotificationData.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 27/04/2021.
//

import Foundation

struct CurrentOrderStateUpdateNotificationData {
    private static let orderIdKey = "ORDER_ID"
    private static let orderStateKey = "ORDER_STATE"
    
    let orderId: String
    let orderState: OrderState
    
    init?(from userInfo: [AnyHashable: Any]) {
        guard let orderId = userInfo[Self.orderIdKey] as? String,
              let orderStateString = userInfo[Self.orderStateKey] as? String,
              let orderState = OrderState(rawValue: orderStateString) else {
            print("Error converting notification data to `CurrentOrderStateUpdateNotificationData`")
            return nil
        }
        self.orderId = orderId
        self.orderState = orderState
    }
}
