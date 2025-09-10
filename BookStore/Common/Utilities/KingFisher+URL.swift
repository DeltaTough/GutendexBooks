//
//  KingFisher+URL.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 09/09/2025.
//

import Foundation
import Kingfisher

extension KFImage {
    init?(_ url: URL?) {
        guard let url = url else { return nil }
        self.init(url)
    }
}
