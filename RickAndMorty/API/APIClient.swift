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
