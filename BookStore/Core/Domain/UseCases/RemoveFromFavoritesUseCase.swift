//
//  RemoveFromFavoritesUseCase.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

protocol RemoveFromFavoritesUseCase {
    func execute(bookId: Int) async throws
}

final class RemoveFromFavoritesUseCaseImpl: RemoveFromFavoritesUseCase {
    private let favoriteRepository: FavoriteRepository
    
    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute(bookId: Int) async throws {
        try await favoriteRepository.removeFromFavorites(bookId: bookId)
    }
}
