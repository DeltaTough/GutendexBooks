//
//  FavoriteRepository.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

protocol FavoriteRepository {
    func getFavorites() async throws -> [FavoriteBook]
    func addToFavorites(book: Book) async throws
    func removeFromFavorites(bookId: Int) async throws
    func isFavorite(bookId: Int) async throws -> Bool
}
