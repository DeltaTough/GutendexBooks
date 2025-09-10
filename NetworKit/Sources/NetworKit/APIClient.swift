//
//  APIClient.swift
//
//  Created by Dimitrios Tsoumanis on 22/08/2025.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public protocol APIClientProtocol {
    func fetch<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T
}

// MARK: - API Client

public final class APIClient: APIClientProtocol {
    private let networkConfig: NetworkConfigurable
    private let session: URLSessionProtocol
    
    public init(networkConfig: NetworkConfigurable, session: URLSessionProtocol? = nil) {
        self.networkConfig = networkConfig
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = networkConfig.headers
        self.session = session ?? URLSession(configuration: configuration)
    }
    
    public func fetch<T>(_ endpoint: any Endpoint, as type: T.Type) async throws -> T where T : Decodable, T : Sendable {
        guard let request = endpoint.urlRequest(
            baseURL: networkConfig.baseURL,
            queryParameters: networkConfig.queryParameters
        ) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
