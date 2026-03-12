//
//  CharacterListFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CharacterListFeature {
    @ObservableState
    struct State: Equatable {
        var isShowingInstructions: Bool = true
        var characters: [Character] = []
        var isLoading: Bool = false
        var errorMessage: String?
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case hideTip
        case cleanList
        case loadCharacters
        case charactersLoaded(Result<[Character], Error>)
        case selectCharacter(Character)
        case destination(PresentationAction<Destination.Action>)
        case retry
    }
    
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case details(CharacterDetailsFeature.State)
        }
        enum Action {
            case details(CharacterDetailsFeature.Action)
        }
        var body: some Reducer<State, Action> {
            Scope(state: \.details, action: \.details) {
                CharacterDetailsFeature()
            }
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .hideTip:
                state.isShowingInstructions = false
                return .none
                
            case .cleanList:
                state.isShowingInstructions = true
                state.characters = []
                state.errorMessage = nil
                return .none
                
            case .loadCharacters:
                state.isLoading = true
                state.isShowingInstructions = false
                state.errorMessage = nil
                return .run { send in
                    do {
                        let characters = try await apiClient.characters()
                        await send(.charactersLoaded(.success(characters)))
                    } catch {
                        await send(.charactersLoaded(.failure(error)))
                    }
                }
                
            case let .charactersLoaded(.success(characters)):
                state.isLoading = false
                state.characters = characters
                state.errorMessage = nil
                return .none
                
            case let .charactersLoaded(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case let .selectCharacter(character):
                state.destination = .details(CharacterDetailsFeature.State(character: character))
                return .none
                
            case .destination(.dismiss):
                state.destination = nil
                return .none
                
            case .destination:
                return .none

            case .retry:
                return .send(.loadCharacters)
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
