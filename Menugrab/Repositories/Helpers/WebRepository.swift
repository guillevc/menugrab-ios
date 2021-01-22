//
//  WebRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import Combine
import FirebaseAuth

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<T: Decodable>(endpoint: APICall, validHTTPStatusCodes: HTTPStatusCodes = .success) -> AnyPublisher<T, Error> {
        return Auth.auth().currentUserIdTokenPublisher()
            .tryMap { try endpoint.urlRequest(baseURL: baseURL, bearerToken: $0) }
            .flatMap { session.dataTaskPublisher(for: $0).mapError { $0 as Error } }
            .tryMap { data, response in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
                }
                guard validHTTPStatusCodes.contains(statusCode) else {
                    throw APIError.httpCode(statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
