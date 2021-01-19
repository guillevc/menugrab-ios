//
//  AppEnvironment.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import Foundation

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
        .init(
            restaurantsWebRepository: RestaurantsWebRepositoryImpl(session: session, baseURL: "http://192.168.0.11:3000/api"),
            imagesWebRepository: ImagesWebRepositoryImpl(session: session, baseURL: "")
        )
    }
    
    private static func configuredServicesContainer(appState: Store<AppState>, webRepositories: WebRepositoriesContainer) -> ServicesContainer {
        .init(
            restaurantsService: RestaurantsServiceImpl(appState: appState, webRepository: webRepositories.restaurantsWebRepository),
            imagesService: ImagesServiceImpl(appState: appState, webRepository: webRepositories.imagesWebRepository)
        )
    }
}
