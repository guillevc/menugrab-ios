//
//  APIError.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation

typealias HTTPStatusCode = Int
typealias HTTPStatusCodes = Range<HTTPStatusCode>

extension HTTPStatusCodes {
    static let success = 200 ..< 300
}

enum APIError: Swift.Error, LocalizedError {
    case invalidURL
    case httpCode(statusCode: HTTPStatusCode, message: String?)
    case unexpectedResponse
    case imageProcessing
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(statusCode, message): return "[HTTP \(statusCode)] \(message ?? "error-message-empty")"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageProcessing: return "Unable to load image"
        }
    }
}

struct APIErrorDTO: Decodable {
    let statusCode: Int
    let error: String
    let message: String
}
