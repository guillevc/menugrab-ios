//
//  AppEnvironment.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation
import FirebaseAuth

struct AppEnvironment {
    let container: DIContainer
    
    private init(container: DIContainer) {
        self.container = container
    }
}

// MARK: - Initializers

extension AppEnvironment {
    private static let apiBaseURL = "http://192.168.2.10:3000/api"
//    private static let apiBaseURL = "https://menugrab.herokuapp.com/api"
    
    static func initialize(orderType: OrderType) -> Self {
        let appState = Store<AppState>(AppState.defaultValue(orderType: orderType))
        let urlSession = configuredURLSession()
        let jsonDecoder = configuredJSONDecoder()
        
        return .init(
            container: .init(
                appState: appState,
                services: configuredServicesContainer(appState: appState, webRepositories: configuredWebRepositoriesContainer(session: urlSession, jsonDecoder: jsonDecoder))
            )
        )
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
//        configuration.urlCache = .shared
        return .init(configuration: configuration)
    }
    
    private static func configuredJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
    
    private static func configuredWebRepositoriesContainer(session: URLSession, jsonDecoder: JSONDecoder) -> WebRepositoriesContainer {
        .init(
            restaurantsWebRepository: RestaurantsWebRepositoryImpl(session: session, baseURL: Self.apiBaseURL, jsonDecoder: jsonDecoder),
            ordersWebRepository: OrdersWebRepositoryImpl(session: session, baseURL: Self.apiBaseURL, jsonDecoder: jsonDecoder),
            imagesWebRepository: ImagesWebRepositoryImpl(session: session, baseURL: "")
        )
    }
    
    private static func configuredServicesContainer(appState: Store<AppState>, webRepositories: WebRepositoriesContainer) -> ServicesContainer {
        .init(
            usersService: UsersServiceImpl(appState: appState),
            restaurantsService: RestaurantsServiceImpl(appState: appState, webRepository: webRepositories.restaurantsWebRepository),
            ordersService: OrdersServiceImpl(appState: appState, webRepository: webRepositories.ordersWebRepository),
            imagesService: ImagesServiceImpl(appState: appState, webRepository: webRepositories.imagesWebRepository),
            userPermissionsService: UserPermissionsServiceImpl(appState: appState)
        )
    }
}
