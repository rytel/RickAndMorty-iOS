//
//  APIClient+Live.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture

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
    let (data, response) = try await urlSession.data(from: url)
    
    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
        throw URLError(.badServerResponse)
    }
    
    return try decoder.decode(T.self, from: data)
}
