//
//  BookApp.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 02/09/2025.
//

import SwiftUI

@main
struct BookApp: App {
    private let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BooksListView(viewModel: dependencies.makeBookListViewModel())
                    .tabItem {
                        Label("Books", systemImage: "books.vertical")
                    }
                FavoriteListView(viewModel: dependencies.makeFavoriteListViewModel())
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
        }
    }
}
