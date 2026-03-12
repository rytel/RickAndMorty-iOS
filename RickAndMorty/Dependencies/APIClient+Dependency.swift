//
//  APIClient+Live.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "RickAndMorty", category: "Networking")

extension APIClient: DependencyKey {
    static let liveValue = Self(
        characters: { url in
            let fetchUrl = try url ?? URLBuilder().allCharacters()
            return try await request(fetchUrl)
        },
        episodes: { urls in
            try await withThrowingTaskGroup(of: Episode.self) { group in
                for urlString in urls {
                    guard let url = URL(string: urlString) else { continue }
                    group.addTask {
                        try await request(url)
                    }
                }
                
                var episodes: [Episode] = []
                for try await episode in group {
                    episodes.append(episode)
                }
                return episodes.sorted { $0.id < $1.id }
            }
        }
    )
    static let testValue = Self(
        characters: { _ in
            PaginatedResponse(
                info: .init(count: 0, pages: 0, next: nil, prev: nil),
                results: []
            )
        },
        episodes: { _ in [] }
    )
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

// MARK: - Generic Helper
private func request<T: Decodable>(_ url: URL) async throws -> T {
    @Dependency(\.jsonDecoder) var decoder
    @Dependency(\.rickAndMortyUrlSession) var urlSession
    
    logger.debug("🚀 Requesting URL: \(url.absoluteString, privacy: .public)")
    
    let (data, response) = try await urlSession.data(from: url)
    
    if let httpResponse = response as? HTTPURLResponse {
        logger.info("✅ Received response (\(httpResponse.statusCode)) for URL: \(url.absoluteString, privacy: .public). Data size: \(data.count) bytes.")
        
        if !(200...299).contains(httpResponse.statusCode) {
            logger.error("❌ Bad status code \(httpResponse.statusCode) for URL: \(url.absoluteString, privacy: .public)")
            throw URLError(.badServerResponse)
        }
    } else {
        logger.warning("❓ Received non-HTTP response for URL: \(url.absoluteString, privacy: .public)")
    }
    
    do {
        return try decoder.decode(T.self, from: data)
    } catch {
        logger.error("❌ Decoding error for URL: \(url.absoluteString, privacy: .public). Error: \(error.localizedDescription)")
        throw error
    }
}
