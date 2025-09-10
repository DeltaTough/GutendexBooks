//
//  FavoriteError.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 07/09/2025.
//

import Foundation

enum FavoriteError: Error, LocalizedError, Equatable {
    case bookAlreadyInFavorites
    case bookNotFound
    case invalidBook(String)
    case storageError(Error)
    case unknown(Error)
    
    static func == (lhs: FavoriteError, rhs: FavoriteError) -> Bool {
        switch (lhs, rhs) {
        case (.bookAlreadyInFavorites, .bookAlreadyInFavorites),
             (.bookNotFound, .bookNotFound):
            return true
        case (.invalidBook(let l), .invalidBook(let r)):
            return l == r
        case (.storageError, .storageError),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .bookAlreadyInFavorites:
            return "This book is already in your favorites."
        case .bookNotFound:
            return "Book not found in the catalog."
        case .invalidBook(let message):
            return "Invalid book: \(message)"
        case .storageError(let error):
            return "Failed to save favorite: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

