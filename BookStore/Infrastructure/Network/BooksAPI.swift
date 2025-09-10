//
//  BooksAPI.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation
import NetworKit

enum BooksAPI: Endpoint {
    case fetchBooks(page: Int)
    
    var method: String {
        return "GET"
    }
    
    var path: String {
        switch self {
            case .fetchBooks:
                return "/books/"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
            case .fetchBooks(let page):
                return [
                    URLQueryItem(name: "page", value: "\(page)")
                ]
        }
    }
}
