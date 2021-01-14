//
//  RestaurantsRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import Combine

protocol RestaurantsWebRepository: WebRepository {
    func loadNearbyRestaurants() -> AnyPublisher<[RestaurantDTO], Error>
    func loadRestaurant(id: String) -> AnyPublisher<RestaurantDTO, Error>
}

struct RestaurantsWebRepositoryImpl: RestaurantsWebRepository {
    let session: URLSession
    let baseURL: String
    
    func loadNearbyRestaurants() -> AnyPublisher<[RestaurantDTO], Error> {
        call(endpoint: RestaurantsWebRepositoryAPI.nearbyRestaurants)
    }
    
    func loadRestaurant(id: String) -> AnyPublisher<RestaurantDTO, Error> {
        call(endpoint: RestaurantsWebRepositoryAPI.restaurant(id: id))
    }
}

// MARK: - Endpoints

fileprivate enum RestaurantsWebRepositoryAPI {
    case nearbyRestaurants
    case restaurant(id: String)
}

extension RestaurantsWebRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .nearbyRestaurants:
            return "/restaurants"
        case .restaurant(let id):
            return "/restaurants/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .nearbyRestaurants, .restaurant:
            return "GET"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .nearbyRestaurants, .restaurant:
            return ["Accept": "application/json"]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .nearbyRestaurants, .restaurant:
            return nil
        }
    }
}
