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
    func createOrder(createOrderDTO: CreateOrderDTO) -> AnyPublisher<Order, Error>
}

struct OrdersWebRepositoryImpl: OrdersWebRepository {
    let session: URLSession
    let baseURL: String
    let jsonDecoder: JSONDecoder
    
    func loadOrdersByUserId(userId: String) -> AnyPublisher<[Order], Error> {
        call(endpoint: OrdersWebRepositoryAPI.ordersByUserId(userId: userId))
    }
    
    func createOrder(createOrderDTO: CreateOrderDTO) -> AnyPublisher<Order, Error> {
        call(endpoint: OrdersWebRepositoryAPI.createOrder(createOrderDTO: createOrderDTO))
    }
}

// MARK: - Endpoints

fileprivate enum OrdersWebRepositoryAPI {
    case ordersByUserId(userId: String)
    case createOrder(createOrderDTO: CreateOrderDTO)
}

extension OrdersWebRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .ordersByUserId(let userId):
            return "/users/\(userId)/orders"
        case .createOrder:
            return "/orders"
        }
    }
    
    var method: String {
        switch self {
        case .ordersByUserId:
            return "GET"
        case .createOrder:
            return "POST"
        }
    }
    
    var headers: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    func body() throws -> Data? {
        switch self {
        case .ordersByUserId:
            return nil
        case .createOrder(let createOrderDTO):
            return try JSONEncoder().encode(createOrderDTO)
        }
    }
}
