//
//  BooksListView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Kingfisher
import SwiftUI

struct BooksListView: View {
    @Bindable var viewModel: BooksListViewModel
    @State private var prefetcher = ImagePrefetcher()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.books.isEmpty {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task { await viewModel.loadBooks() }
                    })
                } else if viewModel.books.isEmpty {
                    EmptyStateView(
                        title: "No Books Available",
                        message: "There are no books in the catalog at the moment.",
                        systemImage: "book.closed"
                    )
                } else {
                    bookList
                }
            }
            .navigationTitle("Books")
            .task {
                await viewModel.loadBooks()
            }
            .overlay(alignment: .top) {
                if let successMessage = viewModel.favoriteSuccessMessage {
                    SuccessToast(message: successMessage)
                }
            }
        }
    }
    
    private var bookList: some View {
        List {
            ForEach(viewModel.books) { book in
                BookRow(book: book, onAddToFavorites: {
                    Task {
                        await viewModel.addToFavorites(book: book)
                    }
                })
                .onAppear {
                    if viewModel.shouldLoadMoreData(book) {
                        Task { await viewModel.loadNextPage() }
                    }
                }
                .task {
                    await prefetchImages(for: book)
                }
                
                if viewModel.isLoadingNextPage && book.id == viewModel.books.last?.id {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadBooks()
        }
    }
    
    private func prefetchImages(for book: Book) async {
        guard let imageUrlString = book.formats.imageJPEG,
              let imageUrl = URL(string: imageUrlString) else { return }
        
        let shouldPrefetch = await !prefetcher.hasPrefetched(imageUrl)
        
        if shouldPrefetch {
            await prefetcher.prefetchIfNeeded(urls: [imageUrl])
        }
    }
}
