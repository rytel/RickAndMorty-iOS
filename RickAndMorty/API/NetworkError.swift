//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Gemini CLI on 13/03/2026.
//

import Foundation

enum NetworkError: Error {
    case tooManyRequests
    case offline
    case other(Error)
    
    var title: String {
        switch self {
        case .offline: return "No Internet"
        case .tooManyRequests: return "Slow Down"
        case .other: return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .offline: return "Please check your connection and try again."
        case .tooManyRequests: return "You've made too many requests. Please wait a moment."
        case let .other(error): return error.localizedDescription
        }
    }
}
