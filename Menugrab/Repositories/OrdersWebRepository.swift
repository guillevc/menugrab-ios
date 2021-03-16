//
//  OrdersWebRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 12/03/2021.
//

import Foundation
import Combine

protocol OrdersWebRepository: WebRepository {
    func loadOrdersByUserId(userId: String) -> AnyPublisher<[Order], Error>
}

struct OrdersWebRepositoryImpl: OrdersWebRepository {
    let session: URLSession
    let baseURL: String
    let jsonDecoder: JSONDecoder
    
    func loadOrdersByUserId(userId: String) -> AnyPublisher<[Order], Error> {
        call(endpoint: OrdersWebRepositoryAPI.ordersByUserId(userId: userId))
    }
}

// MARK: - Endpoints

fileprivate enum OrdersWebRepositoryAPI {
    case ordersByUserId(userId: String)
}

extension OrdersWebRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .ordersByUserId(let userId):
            return "/users/\(userId)/orders"
        }
    }
    
    var method: String {
        switch self {
        case .ordersByUserId:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        switch self {
        case .ordersByUserId:
            return nil
        }
    }
}
