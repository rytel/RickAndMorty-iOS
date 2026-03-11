//
//  Episode.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

struct Episode: Codable, Equatable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
}
