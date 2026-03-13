//
//  NetworkHelper+Dependency.swift
//  RickAndMorty
//
//  Created by Gemini CLI on 13/03/2026.
//

import Foundation
import ComposableArchitecture
import OSLog

extension NetworkHelper: DependencyKey {
    static var liveValue: Self {
        @Dependency(\.rickAndMortyUrlSession) var urlSession
        return Self(
            urlSession: urlSession,
            logger: Logger(subsystem: Bundle.main.bundleIdentifier ?? "RickAndMorty", category: "Networking")
        )
    }
    
    static var testValue: Self {
        Self(
            urlSession: URLSession(configuration: .ephemeral),
            logger: Logger(subsystem: "com.apple.console", category: "Test")
        )
    }
}

extension DependencyValues {
    var networkHelper: NetworkHelper {
        get { self[NetworkHelper.self] }
        set { self[NetworkHelper.self] = newValue }
    }
}
