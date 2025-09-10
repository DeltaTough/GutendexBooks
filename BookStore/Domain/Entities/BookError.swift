//
//  BookError.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 07/09/2025.
//

import Foundation

enum BookError: Error, LocalizedError {
    case noInternetConnection
    case timeout
    case invalidData
    case serverError(Int)
    case unknown(Error)
    case bookNotFound
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. Please try again."
        case .invalidData:
            return "Received invalid data from the server."
        case .serverError(let code):
            return "Server error (code: \(code)). Please try again later."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        case .bookNotFound:
            return "Book not found."
        }
    }
}
