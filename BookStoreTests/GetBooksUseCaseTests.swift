//
//  GetBooksUseCaseTests.swift
//  BookStoreTests
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import Testing
import Foundation
@testable import BookStore

@Suite("GetBooksUseCase Tests")
struct GetBooksUseCaseTests {
    
    @Test("Should fetch books successfully")
    func testExecuteSuccess() async throws {
        // Given
        let mockRepository = MockBookRepository()
        let mockNetworkMonitor = MockNetworkMonitor()
        let useCase = GetBooksUseCaseImpl(
            bookRepository: mockRepository,
            networkMonitor: mockNetworkMonitor
        )
        let expectedBooks = [Book.mock()]
        mockRepository.booksToReturn = expectedBooks
        
        // When
        let result = try await useCase.execute(page: 1)
        
        // Then
        #expect(result.count == 1)
        #expect(result.first?.id == expectedBooks.first?.id)
        #expect(mockRepository.fetchBooksCallCount == 1)
        #expect(mockRepository.lastRequestedPage == 1)
    }
    
    @Test("Should handle repository error")
    func testExecuteRepositoryError() async {
        // Given
        let mockRepository = MockBookRepository()
        let mockNetworkMonitor = MockNetworkMonitor()
        let useCase = GetBooksUseCaseImpl(
            bookRepository: mockRepository,
            networkMonitor: mockNetworkMonitor
        )
        mockRepository.shouldThrowError = true
        
        // When/Then
        await #expect(throws: BookError.networkError) {
            try await useCase.execute(page: 1)
        }
    }
    
    @Test("Should fetch next page successfully")
    func testExecuteNextPage() async throws {
        // Given
        let mockRepository = MockBookRepository()
        let mockNetworkMonitor = MockNetworkMonitor()
        let useCase = GetBooksUseCaseImpl(
            bookRepository: mockRepository,
            networkMonitor: mockNetworkMonitor
        )
        let expectedBooks = [createSampleBook(id: 2)]
        mockRepository.booksToReturn = expectedBooks
        
        // When
        let result = try await useCase.executeNextPage()
        
        // Then
        #expect(result.count == 1)
        #expect(result.first?.id == 2)
        #expect(mockRepository.fetchNextPageCallCount == 1)
    }
    
    @Test("Should get current page correctly")
    func testGetCurrentPage() {
        // Given
        let mockRepository = MockBookRepository()
        let mockNetworkMonitor = MockNetworkMonitor()
        let useCase = GetBooksUseCaseImpl(
            bookRepository: mockRepository,
            networkMonitor: mockNetworkMonitor
        )
        mockRepository.currentPage = 5
        
        // When
        let currentPage = useCase.getCurrentPage()
        
        // Then
        #expect(currentPage == 5)
    }
    
    @Test("Should check if has more pages correctly")
    func testHasMorePages() {
        // Given
        let mockRepository = MockBookRepository()
        let mockNetworkMonitor = MockNetworkMonitor()
        let useCase = GetBooksUseCaseImpl(
            bookRepository: mockRepository,
            networkMonitor: mockNetworkMonitor
        )
        mockRepository.hasNextPage = true
        
        // When
        let hasMore = useCase.hasMorePages()
        
        // Then
        #expect(hasMore == true)
    }
}
