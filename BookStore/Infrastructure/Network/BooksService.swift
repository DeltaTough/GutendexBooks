//
//  BooksService.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation
import NetworKit

protocol BooksServiceProtocol {
    func getBooks(page: Int) async throws -> WebResponseDTO
}

final class BooksService: BooksServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient(
        networkConfig:
            ApiDataNetworkConfig(
                baseURL: URL(
                    string: "http://gutendex.com"
                )!
            ))) {
                self.apiClient = apiClient
            }
    
    func getBooks(page: Int) async throws -> WebResponseDTO {
        try await apiClient.fetch(BooksAPI.fetchBooks(page: page), as: WebResponseDTO.self)
    }
}
