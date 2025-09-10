//
//  BooksListViewModel.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import SwiftUI

@Observable
final class BooksListViewModel {
    private let getBooksUseCase: GetBooksUseCase
    private let addToFavoritesUseCase: AddToFavoritesUseCase
    
    var books: [Book] = []
    var isLoading = false
    var isLoadingNextPage = false
    var error: Error?
    var favoriteSuccessMessage: String?
    var currentPage: Int = 1
    var hasMorePages = true
    
    init(getBooksUseCase: GetBooksUseCase,
         addToFavoritesUseCase: AddToFavoritesUseCase) {
        self.getBooksUseCase = getBooksUseCase
        self.addToFavoritesUseCase = addToFavoritesUseCase
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await ImagePrefetcher().clearCache()
            }
            print("Cleared memory cache on warning")
        }
    }

    @MainActor
    func loadBooks(page: Int = 1) async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            books = try await getBooksUseCase.execute(page: page)
            currentPage = getBooksUseCase.getCurrentPage()
            hasMorePages = getBooksUseCase.hasMorePages()
            
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadNextPage() async {
        guard !isLoadingNextPage && hasMorePages else { return }
        isLoadingNextPage = true
        error = nil
        do {
            let newBooks = try await getBooksUseCase.executeNextPage()
            books.append(contentsOf: newBooks)
            currentPage = getBooksUseCase.getCurrentPage()
            hasMorePages = getBooksUseCase.hasMorePages()
        } catch {
            self.error = error
        }
        
        isLoadingNextPage = false
    }
    
    @MainActor
    func loadPreviousPage() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        do {
            books = try await getBooksUseCase.executePreviousPage()
            currentPage = getBooksUseCase.getCurrentPage()
            hasMorePages = getBooksUseCase.hasMorePages()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func addToFavorites(book: Book) async {
        do {
            try await addToFavoritesUseCase.execute(book: book)
            favoriteSuccessMessage = "\(book.title) added to favorites!"
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                favoriteSuccessMessage = nil
            }
        } catch {
            self.error = error
        }
    }
    
    func shouldLoadMoreData(_ book: Book) -> Bool {
        guard let lastBook = books.last else { return false }
        return book.id == lastBook.id && hasMorePages && !isLoadingNextPage
    }
}
