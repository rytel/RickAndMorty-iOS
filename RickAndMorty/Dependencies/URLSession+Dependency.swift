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
        .shared
    }
}

extension DependencyValues {
    var rickAndMortyUrlSession: URLSession {
        get { self[URLSession.self] }
        set { self[URLSession.self] = newValue }
    }
}
