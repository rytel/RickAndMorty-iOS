//
//  EpisodeDetailsFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture

@Reducer
struct EpisodeDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let episode: Episode
    }
}
