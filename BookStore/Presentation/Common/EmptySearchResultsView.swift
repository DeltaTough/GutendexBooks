//
//  EmptySearchResultsView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import SwiftUI

struct EmptySearchResultsView: View {
    var body: some View {
        EmptyStateView(
            title: "No Results Found",
            message: "Try adjusting your search terms.",
            systemImage: "magnifyingglass"
        )
    }
}
