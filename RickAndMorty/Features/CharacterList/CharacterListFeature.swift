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
        var nextPageURL: URL?
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case hideTip
        case cleanList
        case loadCharacters
        case loadNextPage
        case charactersLoaded(Result<PaginatedResponse<Character>, Error>)
        case selectCharacter(Character)
        case destination(PresentationAction<Destination.Action>)
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
                state.nextPageURL = nil
                return .none
                
            case .loadCharacters:
                state.isLoading = true
                state.isShowingInstructions = false
                state.nextPageURL = nil
                return .run { send in
                    do {
                        let response = try await apiClient.characters(nil)
                        await send(.charactersLoaded(.success(response)))
                    } catch {
                        await send(.charactersLoaded(.failure(error)))
                    }
                }
                
            case .loadNextPage:
                guard !state.isLoading, let nextURL = state.nextPageURL else { return .none }
                state.isLoading = true
                return .run { send in
                    do {
                        let response = try await apiClient.characters(nextURL)
                        await send(.charactersLoaded(.success(response)))
                    } catch {
                        await send(.charactersLoaded(.failure(error)))
                    }
                }
                
            case let .charactersLoaded(.success(response)):
                state.isLoading = false
                state.characters.append(contentsOf: response.results)
                state.nextPageURL = response.info.next
                return .none
                
            case .charactersLoaded(.failure):
                state.isLoading = false
                return .none
                
            case let .selectCharacter(character):
                state.destination = .details(CharacterDetailsFeature.State(character: character))
                return .none
                
            case .destination(.dismiss):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
