//
//  BookRepository.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 06/09/2025.
//

protocol BookRepository {
    func fetchBooks(page: Int) async throws -> [Book]
    func fetchNextPage() async throws -> [Book]
    func fetchPreviousPage() async throws -> [Book]
    func fetchBook(by id: Int) async throws -> Book?
    func getCurrentPage() -> Int
    func hasMorePages() -> Bool
    func resetPagination()
}
