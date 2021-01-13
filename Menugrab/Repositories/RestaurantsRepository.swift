//
//  RestaurantsRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import Combine

protocol RestaurantsRepository: WebRepository {
    func loadNearbyRestaurants() -> AnyPublisher<[RestaurantDTO], Error>
}

struct RestaurantsRepositoryImpl: RestaurantsRepository {
    
    let session: URLSession
    let baseURL: String
    
    func loadNearbyRestaurants() -> AnyPublisher<[RestaurantDTO], Error> {
        call(endpoint: RestaurantsRepositoryAPI.nearbyRestaurants)
    }
}

// MARK: - Endpoints

enum RestaurantsRepositoryAPI {
    case nearbyRestaurants
}

extension RestaurantsRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .nearbyRestaurants:
            return "/api/restaurants"
        }
    }
    
    var method: String {
        switch self {
        case .nearbyRestaurants:
            return "GET"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .nearbyRestaurants:
            return ["Accept": "application/json"]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .nearbyRestaurants:
            return nil
        }
    }
}
