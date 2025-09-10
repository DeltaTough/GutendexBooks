//
//  AppDependencies.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//


final class AppDependencies {
    private lazy var bookService: BooksServiceProtocol = {
        BooksService()
    }()
    
    private lazy var bookRepository: BookRepository = {
        DefaultBookRepository(service: bookService)
    }()
    
    private lazy var favoriteRepository: FavoriteRepository = {
        DefaultFavoriteRepository()
    }()
    
    private lazy var networkMonitor: NetworkMonitoring = {
        NetworkMonitor.shared
    }()
    
    func makeGetBooksUseCase() -> GetBooksUseCase {
        GetBooksUseCaseImpl(bookRepository: bookRepository, networkMonitor: networkMonitor)
    }
    
    func makeAddToFavoritesUseCase() -> AddToFavoritesUseCase {
        AddToFavoritesUseCaseImpl(
            favoriteRepository: favoriteRepository,
            bookRepository: bookRepository
        )
    }
    
    func makeBookListViewModel() -> BooksListViewModel {
        BooksListViewModel(
            getBooksUseCase: makeGetBooksUseCase(),
            addToFavoritesUseCase: makeAddToFavoritesUseCase()
        )
    }
    
    func makeFavoriteListViewModel() -> FavoriteListViewModel {
        FavoriteListViewModel(
            getFavoritesUseCase: makeGetFavoritesUseCase(),
            removeFromFavoritesUseCase: makeRemoveFromFavoritesUseCase()
        )
    }
    
    func makeGetFavoritesUseCase() -> GetFavoritesUseCase {
        GetFavoritesUseCaseImpl(favoriteRepository: favoriteRepository)
    }
    
    func makeRemoveFromFavoritesUseCase() -> RemoveFromFavoritesUseCase {
        RemoveFromFavoritesUseCaseImpl(favoriteRepository: favoriteRepository)
    }
}
