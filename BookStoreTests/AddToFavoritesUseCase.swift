//
//  AddToFavoritesUseCase.swift
//  BookStoreTests
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import Testing
import XCTest
import Foundation
@testable import BookStore

@Suite("AddToFavoritesUseCase Tests")
struct AddToFavoritesUseCaseTests {
    
    @Test("Should add book to favorites successfully")
    func testExecuteSuccess() async throws {
        // Given
        let mockFavoriteRepository = MockFavoriteRepository()
        let mockBookRepository = MockBookRepository()
        let useCase = AddToFavoritesUseCaseImpl(
            favoriteRepository: mockFavoriteRepository,
            bookRepository: mockBookRepository
        )
        let book = createSampleBook()
        
        mockFavoriteRepository.isAlreadyFavorite = false
        mockBookRepository.bookExists = true
        
        // When
        try await useCase.execute(book: book)
        
        // Then
        #expect(mockFavoriteRepository.addToFavoritesCallCount == 1)
        #expect(mockFavoriteRepository.lastAddedBook?.id == book.id)
        #expect(mockBookRepository.fetchBookCallCount == 1)
    }
    
    @Test("Should throw error when book already in favorites")
    func testExecuteBookAlreadyFavorite() async {
        // Given
        let mockFavoriteRepository = MockFavoriteRepository()
        let mockBookRepository = MockBookRepository()
        let useCase = AddToFavoritesUseCaseImpl(
            favoriteRepository: mockFavoriteRepository,
            bookRepository: mockBookRepository
        )
        let book = createSampleBook()
        
        mockFavoriteRepository.isAlreadyFavorite = true
        
        // When/Then
        await #expect(throws: FavoriteError.bookAlreadyInFavorites) {
            try await useCase.execute(book: book)
        }
    }
    
    @Test("Should throw error when book not found")
    func testExecuteBookNotFound() async {
        // Given
        let mockFavoriteRepository = MockFavoriteRepository()
        let mockBookRepository = MockBookRepository()
        let useCase = AddToFavoritesUseCaseImpl(
            favoriteRepository: mockFavoriteRepository,
            bookRepository: mockBookRepository
        )
        let book = createSampleBook()
        
        mockFavoriteRepository.isAlreadyFavorite = false
        mockBookRepository.bookExists = false
        
        // When/Then
        await #expect(throws: FavoriteError.bookNotFound) {
            try await useCase.execute(book: book)
        }
    }
    
    @Test("Should validate book with invalid ID")
    func testExecuteInvalidBookID() async {
        // Given
        let mockFavoriteRepository = MockFavoriteRepository()
        let mockBookRepository = MockBookRepository()
        let useCase = AddToFavoritesUseCaseImpl(
            favoriteRepository: mockFavoriteRepository,
            bookRepository: mockBookRepository
        )
        let invalidBook = createSampleBook(id: 0)
        
        // When/Then
        await #expect(throws: FavoriteError.invalidBook("Book ID cannot be empty")) {
            try await useCase.execute(book: invalidBook)
        }
    }
    
    @Test("Should validate book with empty title")
    func testExecuteInvalidBookTitle() async {
        // Given
        let mockFavoriteRepository = MockFavoriteRepository()
        let mockBookRepository = MockBookRepository()
        let useCase = AddToFavoritesUseCaseImpl(
            favoriteRepository: mockFavoriteRepository,
            bookRepository: mockBookRepository
        )
        let invalidBook = createSampleBook(title: "")
        
        // When/Then
        await #expect(throws: FavoriteError.invalidBook("Book title cannot be empty")) {
            try await useCase.execute(book: invalidBook)
        }

    }
}
