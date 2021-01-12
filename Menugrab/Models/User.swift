//
//  User.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 09/01/2021.
//

import Foundation

struct User {
    let id = UUID()
    let name: String
    let email: String
    let orders: [Order]
}

// MARK: - Samples

extension User {
    static let sampleUser = User(name: "Guillermo Varela", email: "guillermo.varela@email.com", orders: Order.sampleOrders)
}
