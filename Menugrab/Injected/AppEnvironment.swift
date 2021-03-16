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
    static func initialize() -> Self {
        let appState = Store<AppState>(AppState())
        let urlSession = configuredURLSession()
        
        return .init(
            container: .init(
                appState: appState,
                services: configuredServicesContainer(appState: appState, webRepositories: configuredWebRepositoriesContainer(session: urlSession))
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
    
    private static func configuredWebRepositoriesContainer(session: URLSession) -> WebRepositoriesContainer {
        let apiBaseURL = "http://192.168.2.10:3000/api"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return .init(
            restaurantsWebRepository: RestaurantsWebRepositoryImpl(session: session, baseURL: apiBaseURL, jsonDecoder: jsonDecoder),
            ordersWebRepository: OrdersWebRepositoryImpl(session: session, baseURL: apiBaseURL, jsonDecoder: jsonDecoder),
            imagesWebRepository: ImagesWebRepositoryImpl(session: session, baseURL: "")
        )
    }
    
    private static func configuredServicesContainer(appState: Store<AppState>, webRepositories: WebRepositoriesContainer) -> ServicesContainer {
        .init(
            usersService: UsersServiceImpl(appState: appState),
            restaurantsService: RestaurantsServiceImpl(appState: appState, webRepository: webRepositories.restaurantsWebRepository),
            ordersService: OrdersServiceImpl(appState: appState, webRepository: webRepositories.ordersWebRepository),
            imagesService: ImagesServiceImpl(appState: appState, webRepository: webRepositories.imagesWebRepository)
        )
    }
}
