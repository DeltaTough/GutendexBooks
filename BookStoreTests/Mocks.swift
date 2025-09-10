//
//  MockBookRepository.swift
//  BookStoreTests
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import Testing
import Foundation
@testable import BookStore

// MARK: - Helper Functions
func createSampleBook(id: Int = 1, title: String = "Sample Book") -> Book {
    let author = Author(name: "Sample Author")
    let formats = Formats(
        applicationRDFXML: "",
        applicationOctetStream: nil,
        imageJPEG: "image/jpeg",
        textPlainCharsetUsASCII: nil,
        audioMPEG: nil
    )
    
    return Book(
        id: id,
        title: title,
        authors: [author],
        formats: formats
    )
}

func createSampleFavoriteBook(id: Int = 1) -> FavoriteBook {
    let book = createSampleBook(id: id)
    return FavoriteBook(id: id, book: book, addedDate: Date())
}

func createSampleWebResponse() -> WebResponseDTO {
    let bookDTO = BookDTO(
        id: 1,
        title: "Sample Book",
        authors: [AuthorDTO(name: "Sample Author", birthYear: nil, deathYear: nil)],
        subjects: ["Fiction"],
        languages: ["en"],
        copyright: false,
        formats: FormatsDTO(
            applicationRDFXML: "",
            applicationOctetStream: nil,
            imageJPEG: "",
            textPlainCharsetUsASCII: nil,
            audioMPEG: nil
        ),
        downloadCount: 100
    )
    
    return WebResponseDTO(
        count: 1,
        next: "http://example.com/books/?page=2",
        previous: nil,
        results: [bookDTO]
    )
}

// MARK: - Error Types for Testing
enum BookError: Error, Equatable {
    case networkError
    case invalidData
    case notFound
}

enum NetworkError: Error, Equatable {
    case serverError(Int)
    case noConnection
    case timeout
}

// MARK: - Mock Repository Classes

final class MockBookRepository: BookRepository {
    var booksToReturn: [Book] = []
    var shouldThrowError = false
    var bookExists = true
    var currentPage = 1
    var hasNextPage = true
    
    // Call tracking
    var fetchBooksCallCount = 0
    var fetchNextPageCallCount = 0
    var fetchPreviousPageCallCount = 0
    var fetchBookCallCount = 0
    var lastRequestedPage: Int?
    var lastRequestedBookId: Int?
    
    func fetchBooks(page: Int) async throws -> [Book] {
        fetchBooksCallCount += 1
        lastRequestedPage = page
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return booksToReturn
    }
    
    func fetchNextPage() async throws -> [Book] {
        fetchNextPageCallCount += 1
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return booksToReturn
    }
    
    func fetchPreviousPage() async throws -> [Book] {
        fetchPreviousPageCallCount += 1
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return booksToReturn
    }
    
    func fetchBook(by id: Int) async throws -> Book? {
        fetchBookCallCount += 1
        lastRequestedBookId = id
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return bookExists ? booksToReturn.first(where: { $0.id == id }) ?? createSampleBook(id: id) : nil
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func hasMorePages() -> Bool {
        return hasNextPage
    }
    
    func resetPagination() {
        currentPage = 1
        hasNextPage = true
    }
    
    // Helper methods for testing
    func reset() {
        booksToReturn = []
        shouldThrowError = false
        bookExists = true
        currentPage = 1
        hasNextPage = true
        fetchBooksCallCount = 0
        fetchNextPageCallCount = 0
        fetchPreviousPageCallCount = 0
        fetchBookCallCount = 0
        lastRequestedPage = nil
        lastRequestedBookId = nil
    }
}

final class MockFavoriteRepository: FavoriteRepository {    
    var favoritesToReturn: [FavoriteBook] = []
    var isAlreadyFavorite = false
    var shouldThrowAddError = false
    var shouldThrowRemoveError = false
    var shouldThrowGetError = false
    
    // Call tracking
    var getFavoritesCallCount = 0
    var addToFavoritesCallCount = 0
    var removeFromFavoritesCallCount = 0
    var isFavoriteCallCount = 0
    var clearAllFavoritesCallCount = 0
    var lastAddedBook: Book?
    var lastRemovedBookId: Int?
    var lastCheckedBookId: Int?
    
    func getFavorites() async throws -> [FavoriteBook] {
        getFavoritesCallCount += 1
        
        if shouldThrowGetError {
            throw FavoriteError.bookNotFound
        }
        
        return favoritesToReturn
    }
    
    func addToFavorites(book: Book) async throws {
        addToFavoritesCallCount += 1
        lastAddedBook = book
        
        if shouldThrowAddError || isAlreadyFavorite {
            throw FavoriteError.bookAlreadyInFavorites
        }
        
        let favoriteBook = FavoriteBook(id: book.id, book: book, addedDate: Date())
        favoritesToReturn.append(favoriteBook)
    }
    
    func removeFromFavorites(bookId: Int) async throws {
        removeFromFavoritesCallCount += 1
        lastRemovedBookId = bookId
        
        if shouldThrowRemoveError {
            throw FavoriteError.bookNotFound
        }
        
        favoritesToReturn.removeAll { $0.id == bookId }
    }
    
    func isFavorite(bookId: Int) async throws -> Bool {
        isFavoriteCallCount += 1
        lastCheckedBookId = bookId
        return isAlreadyFavorite || favoritesToReturn.contains { $0.id == bookId }
    }
    
    func clearAllFavorites() async throws {
        clearAllFavoritesCallCount += 1
        favoritesToReturn.removeAll()
    }
    
    // Helper methods for testing
    func reset() {
        favoritesToReturn = []
        isAlreadyFavorite = false
        shouldThrowAddError = false
        shouldThrowRemoveError = false
        shouldThrowGetError = false
        getFavoritesCallCount = 0
        addToFavoritesCallCount = 0
        removeFromFavoritesCallCount = 0
        isFavoriteCallCount = 0
        clearAllFavoritesCallCount = 0
        lastAddedBook = nil
        lastRemovedBookId = nil
        lastCheckedBookId = nil
    }
}

final class MockNetworkMonitor: NetworkMonitoring {
    var isConnected = true
    var connectionType: String = "wifi"
    
    var startMonitoringCallCount = 0
    var stopMonitoringCallCount = 0
    
    func startMonitoring() {
        startMonitoringCallCount += 1
    }
    
    func stopMonitoring() {
        stopMonitoringCallCount += 1
    }
    
    func reset() {
        isConnected = true
        connectionType = "wifi"
        startMonitoringCallCount = 0
        stopMonitoringCallCount = 0
    }
}

// MARK: - Mock Use Cases

final class MockGetBooksUseCase: GetBooksUseCase {
    var booksToReturn: [Book] = []
    var nextPageBooks: [Book] = []
    var shouldThrowError = false
    var currentPageValue = 1
    var hasMorePagesValue = true
    
    // Call tracking
    var executeCallCount = 0
    var executeNextPageCallCount = 0
    var executePreviousPageCallCount = 0
    var getCurrentPageCallCount = 0
    var hasMorePagesCallCount = 0
    var lastRequestedPage: Int?
    
    func execute(page: Int) async throws -> [Book] {
        executeCallCount += 1
        lastRequestedPage = page
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return booksToReturn
    }
    
    func executeNextPage() async throws -> [Book] {
        executeNextPageCallCount += 1
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return nextPageBooks.isEmpty ? booksToReturn : nextPageBooks
    }
    
    func executePreviousPage() async throws -> [Book] {
        executePreviousPageCallCount += 1
        
        if shouldThrowError {
            throw BookError.networkError
        }
        
        return booksToReturn
    }
    
    func getCurrentPage() -> Int {
        getCurrentPageCallCount += 1
        return currentPageValue
    }
    
    func hasMorePages() -> Bool {
        hasMorePagesCallCount += 1
        return hasMorePagesValue
    }
    
    func reset() {
        booksToReturn = []
        nextPageBooks = []
        shouldThrowError = false
        currentPageValue = 1
        hasMorePagesValue = true
        executeCallCount = 0
        executeNextPageCallCount = 0
        executePreviousPageCallCount = 0
        getCurrentPageCallCount = 0
        hasMorePagesCallCount = 0
        lastRequestedPage = nil
    }
}

final class MockAddToFavoritesUseCase: AddToFavoritesUseCase {
    var shouldThrowError = false
    var errorToThrow: Error = FavoriteError.bookAlreadyInFavorites
    
    // Call tracking
    var executeCallCount = 0
    var lastAddedBook: Book?
    
    func execute(book: Book) async throws {
        executeCallCount += 1
        lastAddedBook = book
        
        if shouldThrowError {
            throw errorToThrow
        }
    }
    
    func reset() {
        shouldThrowError = false
        errorToThrow = FavoriteError.bookAlreadyInFavorites
        executeCallCount = 0
        lastAddedBook = nil
    }
}

final class MockRemoveFromFavoritesUseCase: RemoveFromFavoritesUseCase {
    var shouldThrowError = false
    
    // Call tracking
    var executeCallCount = 0
    var lastRemovedBookId: Int?
    
    func execute(bookId: Int) async throws {
        executeCallCount += 1
        lastRemovedBookId = bookId
        
        if shouldThrowError {
            throw FavoriteError.bookNotFound
        }
    }
    
    func reset() {
        shouldThrowError = false
        executeCallCount = 0
        lastRemovedBookId = nil
    }
}

// MARK: - Mock Services

final class MockBooksService: BooksServiceProtocol {
    var responseToReturn: WebResponseDTO?
    var shouldThrowError = false
    
    // Call tracking
    var getBooksCallCount = 0
    var lastRequestedPage: Int?
    
    func getBooks(page: Int) async throws -> WebResponseDTO {
        getBooksCallCount += 1
        lastRequestedPage = page
        
        if shouldThrowError {
            throw NetworkError.serverError(500)
        }
        
        return responseToReturn ?? createSampleWebResponse()
    }
    
    func reset() {
        responseToReturn = nil
        shouldThrowError = false
        getBooksCallCount = 0
        lastRequestedPage = nil
    }
}



