//
//  AuthorsView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import SwiftUI

struct AuthorsView: View {
    let authors: [Author]
    var font: Font = .subheadline
    var color: Color = .secondary
    
    private var authorNames: [String] {
        authors.map { $0.name }
    }
    
    var body: some View {
        if authors.isEmpty {
            Text("Unknown Author")
                .font(font)
                .foregroundColor(color)
        } else {
            Text(authorNames.formatted())
                .font(font)
                .foregroundColor(color)
        }
    }
}
