//
//  Endpoint.swift
//
//  Created by Dimitrios Tsoumanis on 22/08/2025.
//

import Foundation

public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public protocol Endpoint: Sendable {
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    func urlRequest(baseURL: URL, queryParameters: [String: String] = [:]) -> URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        var allQueryItems = queryItems ?? []
        allQueryItems.append(contentsOf: queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        if !allQueryItems.isEmpty {
            components?.queryItems = allQueryItems
        }
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
