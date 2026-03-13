//
//  NetworkHelper.swift
//  RickAndMorty
//
//  Created by Gemini CLI on 13/03/2026.
//

import Foundation
import OSLog
import ComposableArchitecture

struct NetworkHelper {
    private let urlSession: URLSession
    private let logger: Logger
    
    init(urlSession: URLSession, logger: Logger) {
        self.urlSession = urlSession
        self.logger = logger
    }
    
    func fetch<T: Decodable>(_ url: URL, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let data = try await performRequest(url)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("❌ Decoding error for URL: \(url.absoluteString, privacy: .public). Error: \(error.localizedDescription)")
            throw NetworkError.other(error)
        }
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        try await performRequest(url)
    }
    
    func performRequest(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        
        logger.debug("🚀 Requesting: \(url.absoluteString, privacy: .public)")
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw mapError(error, url: url)
        }
        
        try validate(response, data: data, url: url)
        return data
    }
    
    private func validate(_ response: URLResponse, data: Data, url: URL) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("❓ Non-HTTP response: \(url.absoluteString, privacy: .public)")
            return
        }
        
        logger.info("✅ Response (\(httpResponse.statusCode)) for: \(url.absoluteString, privacy: .public)")
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 429:
            logger.error("🛑 429 Too Many Requests: \(url.absoluteString, privacy: .public)")
            throw NetworkError.tooManyRequests
        default:
            logger.error("❌ Status \(httpResponse.statusCode) for: \(url.absoluteString, privacy: .public)")
            throw NetworkError.other(URLError(.badServerResponse))
        }
    }
    
    private func mapError(_ error: Error, url: URL) -> NetworkError {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            logger.error("⚠️ Offline: \(url.absoluteString, privacy: .public)")
            return .offline
        }
        logger.error("❌ Network error: \(error.localizedDescription) for: \(url.absoluteString, privacy: .public)")
        return .other(error)
    }
}
