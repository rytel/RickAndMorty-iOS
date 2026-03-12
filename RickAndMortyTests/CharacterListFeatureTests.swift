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
            $0.apiClient.characters = { _ in
                PaginatedResponse(
                    info: .init(count: 1, pages: 1, next: nil, prev: nil),
                    results: mockCharacters
                )
            }
        }
        
        await store.send(CharacterListFeature.Action.loadCharacters) {
            $0.isLoading = true
            $0.isShowingInstructions = false
            $0.nextPageURL = nil
        }
        
        await store.receive(\.charactersLoaded.success) {
            $0.isLoading = false
            $0.characters = mockCharacters
            $0.nextPageURL = nil
        }
    }

    @Test
    func testPagination() async {
        let firstPageCharacters = [
            Character(id: 1, name: "Rick", status: "Alive", gender: "Male", origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [])
        ]
        let secondPageCharacters = [
            Character(id: 2, name: "Morty", status: "Alive", gender: "Male", origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [])
        ]
        let nextURL = URL(string: "https://rickandmortyapi.com/api/character/?page=2")!
        
        let store = TestStore(initialState: CharacterListFeature.State(
            isShowingInstructions: false,
            characters: firstPageCharacters,
            nextPageURL: nextURL
        )) {
            CharacterListFeature()
        } withDependencies: {
            $0.apiClient.characters = { url in
                if url == nextURL {
                    return PaginatedResponse(
                        info: .init(count: 2, pages: 2, next: nil, prev: nil),
                        results: secondPageCharacters
                    )
                }
                fatalError("Unexpected URL")
            }
        }
        
        await store.send(.loadNextPage) {
            $0.isLoading = true
        }
        
        await store.receive(\.charactersLoaded.success) {
            $0.isLoading = false
            $0.characters = firstPageCharacters + secondPageCharacters
            $0.nextPageURL = nil
        }
    }

    @Test
    func testCleanList() async {
        let store = TestStore(initialState: CharacterListFeature.State(
            isShowingInstructions: false,
            characters: [
                Character(id: 1, name: "Rick", status: "Alive", gender: "Male", origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [])
            ],
            nextPageURL: URL(string: "https://next.com")
        )) {
            CharacterListFeature()
        }
        
        await store.send(.cleanList) {
            $0.isShowingInstructions = true
            $0.characters = []
            $0.nextPageURL = nil
        }
    }
}
