//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    var characters: () async throws -> [Character]
    var episodes: ([String]) async throws -> [Episode]
}

// MARK: - Test Value
extension APIClient {
    static let testValue = Self(
        characters: { [] },
        episodes: { _ in [] }
    )
}
