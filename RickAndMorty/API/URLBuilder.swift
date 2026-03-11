//
//  URLBuilder.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import Foundation

struct URLBuilder {
    enum URLBuilderError: Error {
        case invalidURL
    }
    
    enum EndpointBase: String {
        case production = "https://rickandmortyapi.com/api"
    }
    
    enum EndpointPath: String {
        case character = "/character/%@"
        case episode = "/episode/%@"
    }
    
    let base: String
    
    init(base: EndpointBase = .production) {
        self.base = base.rawValue
    }
    
    private func build(_ endpointPath: EndpointPath, _ args: CVarArg...) throws -> URL {
        let path = String(format: endpointPath.rawValue, arguments: args)
        let normalizedBase = base.hasSuffix("/") ? String(base.dropLast()) : base
        
        guard let url = URL(string: normalizedBase + path) else {
            throw URLBuilderError.invalidURL
        }
        return url
    }
    
    //MARK: - Character
    func allCharacters() throws -> URL {
        try build(.character)
    }
    
    func characters(page: Int) throws -> URL {
        try build(.character, "?page=\(page)")
    }
    
    func character(id: Int) throws -> URL {
        try build(.character, String(id))
    }
    
    //MARK: - Episode
    func allEpisodes() throws -> URL {
        try build(.episode)
    }
    
    func episodes(page: Int) throws -> URL {
        try build(.episode, "?page=\(page)")
    }
    
    func episode(id: Int) throws -> URL {
        try build(.episode, String(id))
    }
}
