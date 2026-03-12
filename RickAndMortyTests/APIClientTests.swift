//
//  APIClientTests.swift
//  RickAndMortyTests
//
//  Created by Rafal Rytel on 12/03/2026.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import RickAndMorty

@MainActor
@Suite(.serialized)
class APIClientTests {
    
    @Test
    func testCharactersSuccess() async throws {
        let mockCharacters = [
            Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                gender: "Male",
                origin: .init(name: "Earth", url: ""),
                location: .init(name: "Earth", url: ""),
                image: "",
                episode: []
            )
        ]
        
        let response = PaginatedResponse(
            info: .init(count: 1, pages: 1, next: nil, prev: nil),
            results: mockCharacters
        )
        
        let data = try JSONEncoder().encode(response)
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        try await withDependencies {
            $0.rickAndMortyUrlSession = session
            $0.jsonDecoder = JSONDecoder()
        } operation: {
            let apiClient = APIClient.liveValue
            let characters = try await apiClient.characters()
            #expect(characters == mockCharacters)
        }
    }
    
    @Test
    func testCharactersFailure() async throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        await withDependencies {
            $0.rickAndMortyUrlSession = session
            $0.jsonDecoder = JSONDecoder()
        } operation: {
            let apiClient = APIClient.liveValue
            await #expect(throws: Error.self) {
                try await apiClient.characters()
            }
        }
    }

    @Test
    func testEpisodesSuccess() async throws {
        let mockEpisode = Episode(
            id: 1,
            name: "Pilot",
            air_date: "December 2, 2013",
            episode: "S01E01",
            characters: []
        )
        
        let data = try JSONEncoder().encode(mockEpisode)
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        try await withDependencies {
            $0.rickAndMortyUrlSession = session
            $0.jsonDecoder = JSONDecoder()
        } operation: {
            let apiClient = APIClient.liveValue
            let episodes = try await apiClient.episodes(["https://rickandmortyapi.com/api/episode/1"])
            #expect(episodes == [mockEpisode])
        }
    }
}

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is not set.")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
