//
//  APIClient+Live.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture
import OSLog

extension APIClient: DependencyKey {
    static let liveValue = Self(
        characters: { url in
            @Dependency(\.networkHelper) var networkHelper
            let fetchUrl = try url ?? URLBuilder().allCharacters()
            return try await networkHelper.fetch(fetchUrl)
        },
        episodes: { urls in
            @Dependency(\.networkHelper) var networkHelper
            return try await withThrowingTaskGroup(of: Episode.self) { group in
                for urlString in urls {
                    guard let url = URL(string: urlString) else { continue }
                    group.addTask {
                        try await networkHelper.fetch(url)
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
