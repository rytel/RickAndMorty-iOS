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
        case character = "/character"
        case episode = "/episode"
    }
    
    let base: String
    
    init(base: EndpointBase = .production) {
        self.base = base.rawValue
    }
    
    private func build(_ endpointPath: EndpointPath, _ suffix: String? = nil) throws -> URL {
        let path = base + endpointPath.rawValue + (suffix ?? "")
        
        guard let url = URL(string: path) else {
            throw URLBuilderError.invalidURL
        }
        return url
    }
    
    func allCharacters() throws -> URL {
        try build(.character)
    }
    
    func episode(id: Int) throws -> URL {
        try build(.episode, "/\(id)")
    }
}
