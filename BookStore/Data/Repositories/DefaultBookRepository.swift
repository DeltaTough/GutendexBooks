//
//  DefaultBookRepository.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

import Foundation

final class DefaultBookRepository: BookRepository {
    private let service: BooksServiceProtocol
    private var books: [Int: Book] = [:]
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var nextPageURL: String?
    private var previousPageURL: String?
    
    init(service: BooksServiceProtocol) {
        self.service = service
    }
    
    func fetchBooks(page: Int) async throws -> [Book] {
        let response = try await service.getBooks(page: page)
       // updatePaginationState(from: response, requestedPage: page)
        return processBooks(from: response)
    }
    
    func fetchNextPage() async throws -> [Book] {
        guard hasNextPage else { return [] }
        
        if let nextPageURLString = nextPageURL,
            let url = URL(string: nextPageURLString),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let pageNumber = components.pageNumber() {
            let response = try await service.getBooks(page: pageNumber)
           // updatePaginationState(from: response)
            return processBooks(from: response)
        } else {
            currentPage += 1
            let response = try await service.getBooks(page: currentPage)
           // updatePaginationState(from: response)
            return processBooks(from: response)
        }
    }
    
    func fetchPreviousPage() async throws -> [Book] {
        guard let previousPageURLString = previousPageURL,
              let url = URL(string: previousPageURLString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let pageNumber = components.pageNumber()
        else {
            guard currentPage > 1 else { return [] }
            currentPage -= 1
            let response = try await service.getBooks(page: currentPage)
           // updatePaginationState(from: response)
            return processBooks(from: response)
        }
        
        let response = try await service.getBooks(page: pageNumber)
      //  updatePaginationState(from: response)
        return processBooks(from: response)
    }
    
    func fetchBook(by id: Int) async throws -> Book? {
        books[id]
    }
    
    func getCurrentPage() -> Int {
        currentPage
    }
    
    func hasMorePages() -> Bool {
        hasNextPage
    }
    
    func resetPagination() {
        currentPage = 1
        hasNextPage = true
        nextPageURL = nil
        previousPageURL = nil
        books.removeAll()
    }
    
    // MARK: - Private Methods
    
//    private func updatePaginationState(from response: WebResponseDTO, requestedPage: Int? = nil) {
//        nextPageURL = response.next
//        previousPageURL = response.previous
//        hasNextPage = response.next != nil
//        
//        // Update current page based on response
//        if let currentPageFromResponse = response.currentPageNumber {
//            currentPage = currentPageFromResponse
//        }
//        // Fallback: use the requested page if we can't determine from response
//        else if let requestedPage = requestedPage {
//            currentPage = requestedPage
//        }
//        // If we have next page URL but can't extract page number, increment
//        else if response.next != nil && previousPageURL == nil {
//            currentPage += 1
//        }
//        // If we have previous page URL but can't extract page number, decrement
//        else if nextPageURL == nil {
//            currentPage -= 1
//        }
//    }
    
    private func processBooks(from response: WebResponseDTO) -> [Book] {
        let domainBooks = response.results.map { $0.toDomain() }
        domainBooks.forEach { books[$0.id] = $0 }
        return domainBooks
    }
}
