//
//  URLComponents.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation

extension URLComponents {
    func pageNumber() -> Int? {
        guard let queryItems = queryItems,
              let pageItem = queryItems.first(where: { $0.name == "page" }),
              let pageValue = pageItem.value,
              let pageNumber = Int(pageValue) else {
            return nil
        }
        return pageNumber
    }
}
