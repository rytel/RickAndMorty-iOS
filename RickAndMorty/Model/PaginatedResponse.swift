//
//  PaginatedResponse.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import Foundation

struct PaginatedResponse<T: Codable & Equatable>: Codable, Equatable {
    struct Info: Codable, Equatable {
        let count: Int
        let pages: Int
        let next: URL?
        let prev: URL?
    }
    let info: Info
    let results: [T]
}
