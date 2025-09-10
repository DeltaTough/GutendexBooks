//
//  FavoriteLsitView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import SwiftUI

struct FavoriteListView: View {
    @Bindable var viewModel: FavoriteListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task { await viewModel.loadFavorites() }
                    })
                } else if viewModel.favorites.isEmpty {
                    EmptyFavoritesView()
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
            .task {
                await viewModel.loadFavorites()
            }
        }
    }
    
    private var favoritesList: some View {
        List {
            ForEach(viewModel.favorites) { favorite in
                FavoriteRow(favorite: favorite)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeFromFavorites(bookId: favorite.id)
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                }
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.removeFromFavorites(at: indexSet)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadFavorites()
        }
    }
}

#Preview {
    let dependencies = AppDependencies()
    return FavoriteListView(viewModel: dependencies.makeFavoriteListViewModel())
}
