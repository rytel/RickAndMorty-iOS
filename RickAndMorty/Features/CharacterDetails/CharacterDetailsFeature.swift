//
//  CharacterDetailsFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let character: Character
        var episodes: [Episode] = []
        var isLoading: Bool = false
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case episodesLoaded(Result<[Episode], Error>)
        case selectEpisode(Episode)
        case destination(PresentationAction<Destination.Action>)
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
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.episodes.isEmpty && !state.isLoading else { return .none }
                state.isLoading = true
                let episodeURLs = state.character.episode
                
                return .run { send in
                    do {
                        let episodes = try await apiClient.episodes(episodeURLs)
                        await send(.episodesLoaded(.success(episodes)))
                    } catch {
                        await send(.episodesLoaded(.failure(error)))
                    }
                }
                
            case let .episodesLoaded(.success(episodes)):
                state.isLoading = false
                state.episodes = episodes
                return .none
                
            case .episodesLoaded(.failure):
                state.isLoading = false
                return .none
                
            case let .selectEpisode(episode):
                state.destination = .episodeDetails(EpisodeDetailsFeature.State(episode: episode))
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
