//
//  GetFavoritesUseCase.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

protocol GetFavoritesUseCase {
    func execute() async throws -> [FavoriteBook]
}

final class GetFavoritesUseCaseImpl: GetFavoritesUseCase {
    private let favoriteRepository: FavoriteRepository
    
    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute() async throws -> [FavoriteBook] {
        try await favoriteRepository.getFavorites()
    }
}
