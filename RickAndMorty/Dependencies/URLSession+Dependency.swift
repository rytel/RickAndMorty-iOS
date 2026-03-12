//
//  URLSession+Dependency.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture

extension URLSession: DependencyKey {
    public static var liveValue: URLSession {
        let config = URLSessionConfiguration.default
        config.urlCache = .rickAndMorty
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config)
    }
}

extension URLCache: DependencyKey {
    public static var liveValue: URLCache {
        .rickAndMorty
    }
}

extension URLCache {
    static let rickAndMorty = URLCache(
        memoryCapacity: 100 * 1024 * 1024, // 100 MB
        diskCapacity: 1000 * 1024 * 1024,  // 1000 MB
        diskPath: "rick_and_morty_cache"
    )
}

extension DependencyValues {
    var rickAndMortyUrlSession: URLSession {
        get { self[URLSession.self] }
        set { self[URLSession.self] = newValue }
    }
    
    var urlCache: URLCache {
        get { self[URLCache.self] }
        set { self[URLCache.self] = newValue }
    }
}
