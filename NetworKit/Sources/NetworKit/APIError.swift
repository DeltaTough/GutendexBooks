//
//  APIError.swift
//
//  Created by Dimitrios Tsoumanis on 22/08/2025.
//

import Foundation

public enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    
    public static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.decodingError, .decodingError):
            return false
        default:
            return false
        }
    }
}
