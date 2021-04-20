//
//  UsersWebRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 20/04/2021.
//

import Foundation
import Combine

protocol UsersWebRepository: WebRepository {
    func updateFCMToken(userId: String, fcmTokenDTO: FCMTokenDTO) -> AnyPublisher<FCMTokenDTO, Error>
}

struct UsersWebRepositoryImpl: UsersWebRepository {
    let session: URLSession
    let baseURL: String
    let jsonDecoder: JSONDecoder
    
    func updateFCMToken(userId: String, fcmTokenDTO: FCMTokenDTO) -> AnyPublisher<FCMTokenDTO, Error> {
        call(endpoint: UsersWebRepositoryAPI.updateFCMToken(userId: userId, fcmTokenDTO: fcmTokenDTO))
    }
}

// MARK: - Endpoints

fileprivate enum UsersWebRepositoryAPI {
    case updateFCMToken(userId: String, fcmTokenDTO: FCMTokenDTO)
}

extension UsersWebRepositoryAPI: APICall {
    var path: String {
        switch self {
        case .updateFCMToken(let userId, _):
            return "/users/\(userId)/fcm-token"
        }
    }
    
    var method: String {
        switch self {
        case .updateFCMToken:
            return "PUT"
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
        case .updateFCMToken(_, let fcmTokenDTO):
            return try JSONEncoder().encode(fcmTokenDTO)
        }
    }
}
