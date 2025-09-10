//
//  AddToFavoritesUseCase.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

protocol AddToFavoritesUseCase {
    func execute(book: Book) async throws
}

final class AddToFavoritesUseCaseImpl: AddToFavoritesUseCase {
    private let favoriteRepository: FavoriteRepository
    private let bookRepository: BookRepository
    
    init(favoriteRepository: FavoriteRepository, bookRepository: BookRepository) {
        self.favoriteRepository = favoriteRepository
        self.bookRepository = bookRepository
    }
    
    func execute(book: Book) async throws {
        try validateBook(book)
        
        let isAlreadyFavorite = try await favoriteRepository.isFavorite(bookId: book.id)
        
        guard !isAlreadyFavorite else {
            throw FavoriteError.bookAlreadyInFavorites
        }
        let existingBook = try await bookRepository.fetchBook(by: book.id)
        guard existingBook != nil else {
            throw FavoriteError.bookNotFound
        }
        try await favoriteRepository.addToFavorites(book: book)
    }
    
    private func validateBook(_ book: Book) throws {
        guard book.id > 0 else {
            throw FavoriteError.invalidBook("Book ID cannot be empty")
        }
        
        guard !book.title.isEmpty else {
            throw FavoriteError.invalidBook("Book title cannot be empty")
        }
        
        guard !book.authors.isEmpty else {
            throw FavoriteError.invalidBook("Book author cannot be empty")
        }
    }
}
