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
        var episodeIDs: [Int] = []
        var isLoading: Bool = false
        var errorMessage: String?
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case selectEpisode(Int)
        case episodeLoaded(Result<Episode, Error>)
        case destination(PresentationAction<Destination.Action>)
        case retry
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
                state.episodeIDs = state.character.episode.compactMap { urlString in
                    URL(string: urlString)?.lastPathComponent
                }.compactMap { Int($0) }
                return .none
                
            case let .selectEpisode(id):
                state.isLoading = true
                state.errorMessage = nil
                let url = "https://rickandmortyapi.com/api/episode/\(id)"
                
                return .run { send in
                    do {
                        let episodes = try await apiClient.episodes([url])
                        if let episode = episodes.first {
                            await send(.episodeLoaded(.success(episode)))
                        }
                    } catch {
                        await send(.episodeLoaded(.failure(error)))
                    }
                }
                
            case let .episodeLoaded(.success(episode)):
                state.isLoading = false
                state.destination = .episodeDetails(EpisodeDetailsFeature.State(episode: episode))
                return .none
                
            case let .episodeLoaded(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .destination:
                return .none

            case .retry:
                state.errorMessage = nil
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
