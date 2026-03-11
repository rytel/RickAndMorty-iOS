//
//  Character.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}
