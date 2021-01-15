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

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPStatusCode)
    case unexpectedResponse
    case imageProcessing
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageProcessing: return "Unable to load image"
        }
    }
}
