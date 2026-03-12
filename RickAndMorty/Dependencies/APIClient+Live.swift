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
        characters: {
            let url = try URLBuilder().allCharacters()
            let response: PaginatedResponse<Character> = try await request(url)
            return response.results
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
    let (data, response) = try await URLSession.shared.data(from: url)
    
    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
        throw URLError(.badServerResponse)
    }
    
    return try decoder.decode(T.self, from: data)
}
