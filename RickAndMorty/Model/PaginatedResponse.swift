//
//  PaginatedResponse.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import Foundation

struct PaginatedResponse<T: Decodable>: Decodable {
    struct Info: Decodable {
        let count: Int
        let pages: Int
        let next: URL?
        let prev: URL?
    }
    let info: Info
    let results: [T]
}
