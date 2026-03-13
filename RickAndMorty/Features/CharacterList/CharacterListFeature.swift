//
//  CharacterListFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct CharacterListFeature {
    @ObservableState
    struct State: Equatable {
        var isShowingInstructions: Bool = true
        var characters: [Character] = []
        var isLoading: Bool = false
        var nextPageURL: URL?
        @Presents var destination: Destination.State?
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case hideTip
        case cleanList
        case loadCharacters
        case loadNextPage
        case charactersLoaded(Result<PaginatedResponse<Character>, Error>)
        case selectCharacter(Character)
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case retryInitial
            case retryNextPage
        }
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
                
            case let .charactersLoaded(.failure(error)):
                state.isLoading = false
                let networkError = (error as? NetworkError) ?? .other(error)
                let retryAction: Action.Alert = state.characters.isEmpty ? .retryInitial : .retryNextPage
                
                state.alert = AlertState {
                    TextState(networkError.title)
                } actions: {
                    ButtonState(action: .send(retryAction)) {
                        TextState("Retry")
                    }
                    ButtonState(role: .cancel) {
                        TextState("OK")
                    }
                } message: {
                    TextState(networkError.message)
                }
                return .none
                
            case let .selectCharacter(character):
                state.destination = .details(CharacterDetailsFeature.State(character: character))
                return .none
                
            case .alert(.presented(.retryInitial)):
                return .send(.loadCharacters)
                
            case .alert(.presented(.retryNextPage)):
                return .send(.loadNextPage)
                
            case .alert(.dismiss):
                return .none
                
            case .alert:
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
        .ifLet(\.$alert, action: \.alert)
    }
}
