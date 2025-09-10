//
//  BookRow.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Kingfisher
import SwiftUI

struct BookRow: View {
    let book: Book
    let onAddToFavorites: () -> Void
    @State private var showSuccess: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: book.formats.imageJPEG ?? ""))
                .placeholder { ProgressView() }
                .resizable()
                .cancelOnDisappear(true)
                .memoryCacheExpiration(.seconds(6000))
                .diskCacheExpiration(.days(7))
                .scaledToFit()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                AuthorsView(
                    authors: book.authors,
                    font: .body,
                    color: .primary
                )
                Spacer()
                
                // Simple favorite button
                Button(action: {
                    onAddToFavorites()
                    withAnimation {
                        showSuccess = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showSuccess = false
                        }
                    }
                }) {
                    Image(systemName: showSuccess ? "checkmark" : "heart")
                        .foregroundColor(showSuccess ? .green : .blue)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 44, height: 44)
                        .background(showSuccess ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}
