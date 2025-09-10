//
//  WebResponseDTO.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 02/09/2025.
//

import Foundation

struct WebResponseDTO: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [BookDTO]
    
    var currentPageNumber: Int? {
        if let previous = previousPage {
            return previous + 1
        }
        else if let next = nextPage {
            return next - 1
        }
        else if next == nil {
            return previousPage
        }
        return nil
    }
}

extension WebResponseDTO {
    var nextPage: Int? {
        guard let next = next, let url = URL(string: next), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.pageNumber()
    }
    
    var previousPage: Int? {
        guard let previous = previous, let url = URL(string: previous), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.pageNumber()
    }
}

