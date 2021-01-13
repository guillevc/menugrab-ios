//
//  WebRepository.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
//    var backgroundQueue: DispatchQueue { get }
}

extension WebRepository {
    
    func call<T: Decodable>(endpoint: APICall, validHTTPStatusCodes: HTTPStatusCodes = .success) -> AnyPublisher<T, Error> {
        do {
//            assert(!Thread.isMainThread)
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .tryMap { // (data: Data, response: URLResponse)
                    guard let statusCode = ($0.1 as? HTTPURLResponse)?.statusCode else {
                        throw APIError.unexpectedResponse
                    }
                    guard validHTTPStatusCodes.contains(statusCode) else {
                        throw APIError.httpCode(statusCode)
                    }
                    return $0.0
                }
                // extractUnderlyingError
//                .mapError {
//                    ($0.underlyingError as? Failure) ?? $0
//                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
                
        } catch let error {
            return Fail<T, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
}
