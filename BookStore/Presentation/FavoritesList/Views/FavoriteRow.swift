//
//  FavoriteRow.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Kingfisher
import SwiftUI

struct FavoriteRow: View {
    let favorite: FavoriteBook
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: favorite.book.formats.imageJPEG ?? ""))
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.book.title)
                    .font(.headline)
                    .lineLimit(2)
                AuthorsView(
                    authors: favorite.book.authors
                )
                Text("Added \(favorite.addedDate, format: .relative(presentation: .named))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
