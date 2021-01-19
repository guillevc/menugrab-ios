//
//  RestaurantsRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import Combine

protocol RestaurantsWebRepository: WebRepository {
    func loadNearbyRestaurants(latitude: Double?, longitude: Double?) -> AnyPublisher<[Restaurant], Error>
    func loadRestaurant(id: String) -> AnyPublisher<Restaurant, Error>
}

struct RestaurantsWebRepositoryImpl: RestaurantsWebRepository {
    let session: URLSession
    let baseURL: String
    
    func loadNearbyRestaurants(latitude: Double?, longitude: Double?) -> AnyPublisher<[Restaurant], Error> {
        call(endpoint: RestaurantsWebRepositoryAPI.nearbyRestaurants(latitude: latitude?.description, longitude: longitude?.description))
    }
    
    func loadRestaurant(id: String) -> AnyPublisher<Restaurant, Error> {
        call(endpoint: RestaurantsWebRepositoryAPI.restaurant(id: id))
    }
}

// MARK: - Endpoints

fileprivate enum RestaurantsWebRepositoryAPI {
    case nearbyRestaurants(latitude: String?, longitude: String?)
    case restaurant(id: String)
}

extension RestaurantsWebRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .nearbyRestaurants(let latitude, let longitude):
            let restaurantsUrl = "/restaurants"
            guard let latitude = latitude,
                  let longitude = longitude,
                  var urlComponents = URLComponents(string: restaurantsUrl) else { return restaurantsUrl }
            let latitudeQueryItem = URLQueryItem(name: "latitude", value: latitude)
            let longitudeQueryItem = URLQueryItem(name: "longitude", value: longitude)
            urlComponents.queryItems = [latitudeQueryItem, longitudeQueryItem]
            return urlComponents.url?.absoluteString ?? restaurantsUrl
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
