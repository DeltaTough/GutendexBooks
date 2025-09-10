//
//  FavoriteBook.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation

struct FavoriteBook: Identifiable {
    let id: Int
    let book: Book
    let addedDate: Date
}
