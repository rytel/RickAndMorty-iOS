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
        
        await store.send(.loadCharacters) {
            $0.isLoading = true
            $0.isShowingInstructions = false
        }
        
        await store.receive(\.charactersLoaded.success) {
            $0.isLoading = false
            $0.characters = mockCharacters
        }
    }
    
    @Test
    func testLoadCharactersFailure() async {
        struct MockError: Error, LocalizedError, Equatable {
            var errorDescription: String? { "Network error" }
        }
        
        let store = TestStore(initialState: CharacterListFeature.State()) {
            CharacterListFeature()
        } withDependencies: {
            $0.apiClient.characters = { throw MockError() }
        }
        
        await store.send(.loadCharacters) {
            $0.isLoading = true
            $0.isShowingInstructions = false
        }
        
        await store.receive(\.charactersLoaded.failure) {
            $0.isLoading = false
            $0.errorMessage = "Network error"
        }
    }
    
    @Test
    func testRetry() async {
        let store = TestStore(initialState: CharacterListFeature.State(errorMessage: "Initial error")) {
            CharacterListFeature()
        } withDependencies: {
            $0.apiClient.characters = { [] }
        }
        
        await store.send(.retry)
        
        await store.receive(\.loadCharacters) {
            $0.isLoading = true
            $0.errorMessage = nil
            $0.isShowingInstructions = false
        }
        
        await store.receive(\.charactersLoaded.success) {
            $0.isLoading = false
            $0.characters = []
        }
    }
}
