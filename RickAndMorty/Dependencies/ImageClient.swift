//
//  ImageClient.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import UIKit
import ComposableArchitecture
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "RickAndMorty", category: "Images")

struct ImageClient {
    var image: (URL) async throws -> UIImage
}

extension ImageClient: DependencyKey {
    static let liveValue = Self(
        image: { url in
            if let cached = ImageCache.shared.get(for: url) {
                logger.debug("🖼️ Using cached image for URL: \(url.absoluteString, privacy: .public)")
                return cached
            }
            
            @Dependency(\.rickAndMortyUrlSession) var urlSession
            let helper = NetworkHelper(urlSession: urlSession, logger: logger)
            let data = try await helper.performRequest(url)
            
            guard let image = UIImage(data: data) else {
                logger.error("❌ Could not decode image data for URL: \(url.absoluteString, privacy: .public)")
                throw URLError(.cannotDecodeContentData)
            }
            
            ImageCache.shared.set(image, for: url)
            return image
        }
    )
}

extension DependencyValues {
    var imageClient: ImageClient {
        get { self[ImageClient.self] }
        set { self[ImageClient.self] = newValue }
    }
}

// MARK: - ImageCache

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 1000
    }
    
    func get(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
