//
//  URLBuilder+Dependency.swift
//  RickAndMorty
//
//  Created by Gemini CLI on 13/03/2026.
//

import ComposableArchitecture

extension URLBuilder: DependencyKey {
    static let liveValue = URLBuilder()
    static let testValue = URLBuilder()
}

extension DependencyValues {
    var urlBuilder: URLBuilder {
        get { self[URLBuilder.self] }
        set { self[URLBuilder.self] = newValue }
    }
}
