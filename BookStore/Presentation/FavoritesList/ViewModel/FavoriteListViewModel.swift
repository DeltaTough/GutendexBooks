//
//  FavoriteListViewModel.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import SwiftUI

@Observable
final class FavoriteListViewModel {
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFromFavoritesUseCase: RemoveFromFavoritesUseCase
    
    var favorites: [FavoriteBook] = []
    var isLoading = false
    var error: Error?
    
    init(getFavoritesUseCase: GetFavoritesUseCase,
         removeFromFavoritesUseCase: RemoveFromFavoritesUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFromFavoritesUseCase = removeFromFavoritesUseCase
    }
    
    @MainActor
    func loadFavorites() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            favorites = try await getFavoritesUseCase.execute()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func removeFromFavorites(bookId: Int) async {
        do {
            try await removeFromFavoritesUseCase.execute(bookId: bookId)
            await loadFavorites()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func removeFromFavorites(at offsets: IndexSet) async {
        for index in offsets {
            let favorite = favorites[index]
            await removeFromFavorites(bookId: favorite.id)
        }
    }
}
