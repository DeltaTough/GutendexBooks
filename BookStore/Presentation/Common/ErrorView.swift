//
//  ErrorView.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(error.localizedDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: retryAction) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct NetworkErrorView: View {
    let retryAction: () -> Void
    
    var body: some View {
        ErrorView(
            error: BookError.noInternetConnection,
            retryAction: retryAction
        )
    }
}

// Preview
#Preview {
    Group {
        ErrorView(
            error: BookError.noInternetConnection,
            retryAction: {}
        )
        
        EmptyFavoritesView()
        
        NetworkErrorView(retryAction: {})
    }
}

