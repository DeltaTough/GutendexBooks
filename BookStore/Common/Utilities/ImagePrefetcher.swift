//
//  ImagePrefetcher.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation
import Kingfisher

actor ImagePrefetcher {
    private var prefetchedURLs: Set<URL> = []
    private let maxCachedImages = 50
    
    init() {}
    
    func prefetchIfNeeded(urls: [URL]) {
        let newURLs = urls.filter { !prefetchedURLs.contains($0) }
        guard !newURLs.isEmpty else { return }
        
        let prefetcher = Kingfisher.ImagePrefetcher(
            resources: newURLs,
            options: [
                .processor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 160))),
                .cacheOriginalImage
            ]
        )
        
        prefetcher.start()
        newURLs.forEach { prefetchedURLs.insert($0) }
        
        if prefetchedURLs.count > maxCachedImages {
            let excess = prefetchedURLs.count - maxCachedImages
            let urlsToRemove = Array(prefetchedURLs.prefix(excess))
            urlsToRemove.forEach { prefetchedURLs.remove($0) }
        }
    }
    
    func hasPrefetched(_ url: URL) -> Bool {
        prefetchedURLs.contains(url)
    }
    
    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        prefetchedURLs.removeAll()
    }
}
