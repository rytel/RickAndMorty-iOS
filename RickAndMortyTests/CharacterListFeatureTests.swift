//
//  CharacterListFeatureTests.swift
//  RickAndMortyTests
//
//  Created by Rafal Rytel on 12/03/2026.
//

import ComposableArchitecture
import Foundation
import Testing
@testable import RickAndMorty

@MainActor
struct CharacterListFeatureTests {
    
    @Test
    func testLoadCharactersSuccess() async {
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
        
        let store = TestStore(initialState: CharacterListFeature.State()) {
            CharacterListFeature()
        } withDependencies: {
            $0.apiClient.characters = { mockCharacters }
        }
        
        await store.send(CharacterListFeature.Action.loadCharacters) {
            $0.isLoading = true
            $0.isShowingInstructions = false
        }
        
        await store.receive(\.charactersLoaded.success) {
            $0.isLoading = false
            $0.characters = mockCharacters
        }
    }
}
