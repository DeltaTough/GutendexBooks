//
//  DefaultFavoriteRespository.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation

final class DefaultFavoriteRepository: FavoriteRepository {
    private var favorites: [Int: FavoriteBook] = [:]
    
    func getFavorites() async throws -> [FavoriteBook] {
        return Array(favorites.values).sorted { $0.addedDate > $1.addedDate }
    }
    
    func addToFavorites(book: Book) async throws {
        guard favorites[book.id] == nil else {
            throw FavoriteError.bookAlreadyInFavorites
        }
        
        let favoriteBook = FavoriteBook(id: book.id, book: book, addedDate: Date())
        favorites[book.id] = favoriteBook
    }
    
    func removeFromFavorites(bookId: Int) async throws {
        guard favorites.removeValue(forKey: bookId) != nil else {
            throw FavoriteError.bookNotFound
        }
    }
    
    func isFavorite(bookId: Int) async throws -> Bool {
        return favorites[bookId] != nil
    }
    
    func clearAllFavorites() async throws {
        favorites.removeAll()
    }
    
    // Helper method for testing
    func getFavoriteCount() -> Int {
        favorites.count
    }
}
