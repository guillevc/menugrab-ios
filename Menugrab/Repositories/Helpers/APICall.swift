//
//  APICall.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 13/01/2021.
//

import Foundation

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

extension APICall {
    func urlRequest(baseURL: String, bearerToken: String?) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        var allHeaders = headers ?? [String: String]()
        if let token = bearerToken {
            allHeaders.updateValue("Bearer \(token)", forKey: "Authorization")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = allHeaders
        request.httpBody = try body()
        return request
    }
}
