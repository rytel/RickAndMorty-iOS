//
//  CharacterModelTests.swift
//  RickAndMortyTests
//
//  Created by Gemini CLI on 13/03/2026.
//

import Testing
import Foundation
@testable import RickAndMorty

@Suite
struct CharacterModelTests {
    @Test
    func testEpisodeIDsExtraction() {
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            gender: "Male",
            origin: .init(name: "", url: ""),
            location: .init(name: "", url: ""),
            image: "",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/25",
                "https://rickandmortyapi.com/api/episode/invalid"
            ]
        )
        
        #expect(character.episodeIDs == [1, 25])
    }
    
    @Test
    func testEmptyEpisodes() {
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            gender: "Male",
            origin: .init(name: "", url: ""),
            location: .init(name: "", url: ""),
            image: "",
            episode: []
        )
        
        #expect(character.episodeIDs.isEmpty)
    }
}
