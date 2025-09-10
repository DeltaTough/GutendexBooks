//
//  FavoriteBookTests.swift
//  BookStoreTests
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import Testing
import Foundation
@testable import BookStore

@Suite("FavoriteBook Domain Model Tests")
struct FavoriteBookTests {
    
    @Test("FavoriteBook should be created with current date")
    func testFavoriteBookCreation() {
        // Given
        let book = Book.mock()
        let beforeDate = Date()
        
        // When
        let favoriteBook = FavoriteBook(id: book.id, book: book, addedDate: Date())
        let afterDate = Date()
        
        // Then
        #expect(favoriteBook.id == book.id)
        #expect(favoriteBook.book.id == book.id)
        #expect(favoriteBook.addedDate >= beforeDate)
        #expect(favoriteBook.addedDate <= afterDate)
    }
}
