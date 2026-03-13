//
//  URLBuilderTests.swift
//  RickAndMortyTests
//
//  Created by Gemini CLI on 13/03/2026.
//

import Testing
import Foundation
@testable import RickAndMorty

@Suite
struct URLBuilderTests {
    let builder = URLBuilder()
    
    @Test
    func testAllCharactersURL() throws {
        let url = try builder.allCharacters()
        #expect(url.absoluteString == "https://rickandmortyapi.com/api/character")
    }
    
    @Test
    func testEpisodeWithIDURL() throws {
        let url = try builder.episode(id: 1)
        #expect(url.absoluteString == "https://rickandmortyapi.com/api/episode/1")
    }
}
