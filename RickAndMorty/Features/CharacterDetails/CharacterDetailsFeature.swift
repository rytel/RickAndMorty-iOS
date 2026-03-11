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
    }
    
    enum Action {
        case onAppear
        case episodesLoaded(Result<[Episode], Error>)
        case selectEpisode(Episode)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let episodeURLs = state.character.episode
                return .run { send in
                    do {
                        var episodes: [Episode] = []
                        for urlString in episodeURLs {
                            guard let url = URL(string: urlString) else { continue }
                            let (data, _) = try await URLSession.shared.data(from: url)
                            let episode = try JSONDecoder().decode(Episode.self, from: data)
                            episodes.append(episode)
                        }
                        await send(.episodesLoaded(.success(episodes)))
                    } catch {
                        await send(.episodesLoaded(.failure(error)))
                    }
                }
                
            case let .episodesLoaded(.success(episodes)):
                state.isLoading = false
                state.episodes = episodes
                return .none
                
            case let .episodesLoaded(.failure(error)):
                state.isLoading = false
                // handle error
                return .none
                
            case .selectEpisode:
                return .none
            }
        }
    }
}
