//
//  JSONDecoder+Dependency.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import Foundation
import ComposableArchitecture

enum JSONDecoderKey: DependencyKey {
    static let liveValue = JSONDecoder()
    static let testValue = JSONDecoder()
}

extension DependencyValues {
    var jsonDecoder: JSONDecoder {
        get { self[JSONDecoderKey.self] }
        set { self[JSONDecoderKey.self] = newValue }
    }
}
