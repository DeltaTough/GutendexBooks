//
//  EmptyFavoritesView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 10/09/2025.
//

import SwiftUI

struct EmptyFavoritesView: View {
    var body: some View {
        EmptyStateView(
            title: "No Favorites Yet",
            message: "Books you add to favorites will appear here.",
            systemImage: "heart.slash"
        )
    }
}
