//
//  GetBooksUseCase.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

import Foundation

protocol GetBooksUseCase {
    func execute(page: Int) async throws -> [Book]
    func executeNextPage() async throws -> [Book]
    func executePreviousPage() async throws -> [Book]
    func getCurrentPage() -> Int
    func hasMorePages() -> Bool
}

final class GetBooksUseCaseImpl: GetBooksUseCase {
    private let bookRepository: BookRepository
    private let networkMonitor: NetworkMonitoring
    
    init(bookRepository: BookRepository, networkMonitor: NetworkMonitoring) {
        self.bookRepository = bookRepository
        self.networkMonitor = networkMonitor
    }
    
    func execute(page: Int) async throws -> [Book] {
        try await bookRepository.fetchBooks(page: page)
    }
    
    func executeNextPage() async throws -> [Book] {
        try await bookRepository.fetchNextPage()
    }
    
    func executePreviousPage() async throws -> [Book] {
        try await bookRepository.fetchPreviousPage()
    }
    
    func getCurrentPage() -> Int {
        bookRepository.getCurrentPage()
    }
    
    func hasMorePages() -> Bool {
        bookRepository.hasMorePages()
    }
}
