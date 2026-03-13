//
//  CharacterDetailsFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct CharacterDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let character: Character
        var episodes: [Episode] = []
        var isLoading: Bool = false
        var episodeIDs: [Int] = []
        var lastSelectedEpisodeID: Int?
        @Presents var destination: Destination.State?
        @Presents var alert: AlertState<Action.Alert>?
    }

    enum Action {
        case onAppear
        case selectEpisode(Int)
        case episodeLoaded(Result<Episode, Error>)
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)

        enum Alert: Equatable {
            case retry(Int)
        }
    }

    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case episodeDetails(EpisodeDetailsFeature.State)
        }
        enum Action {
            case episodeDetails(EpisodeDetailsFeature.Action)
        }
        var body: some Reducer<State, Action> {
            Scope(state: \.episodeDetails, action: \.episodeDetails) {
                EpisodeDetailsFeature()
            }
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.urlBuilder) var urlBuilder
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.episodeIDs = state.character.episodeIDs
                return .none
                
            case let .selectEpisode(id):
                state.isLoading = true
                state.lastSelectedEpisodeID = id
                
                return .run { [urlBuilder] send in
                    do {
                        let url = try urlBuilder.episode(id: id)
                        let episodes = try await apiClient.episodes([url.absoluteString])
                        if let episode = episodes.first {
                            await send(.episodeLoaded(.success(episode)))
                        }
                    } catch {
                        await send(.episodeLoaded(.failure(error)))
                    }
                }
                case let .episodeLoaded(.success(episode)):
                    state.isLoading = false
                    state.episodes.append(episode)
                    state.destination = .episodeDetails(EpisodeDetailsFeature.State(episode: episode))
                    return .none

                case let .episodeLoaded(.failure(error)):
                    state.isLoading = false
                    let networkError = (error as? NetworkError) ?? .other(error)
                    let retryID = state.lastSelectedEpisodeID

                    state.alert = AlertState {
                        TextState(networkError.title)
                    } actions: {
                        if let id = retryID {
                            ButtonState(action: .retry(id)) {
                                TextState("Retry")
                            }
                        }
                        ButtonState(role: .cancel) {
                            TextState("OK")
                        }
                    } message: {
                        TextState(networkError.message)
                    }
                    return .none

                case let .alert(.presented(.retry(id))):
                    return .send(.selectEpisode(id))

                case .alert:
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

