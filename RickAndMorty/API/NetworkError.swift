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
}
