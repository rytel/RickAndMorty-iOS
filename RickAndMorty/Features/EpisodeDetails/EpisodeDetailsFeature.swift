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
    struct State {
        
    }
    
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}


/*
 EpisodeDetailsView wyświetlającego takie pola jak:
 ⁃ Name
 ⁃ air_date
 ⁃ Episode
 
 Dodatkowo powinien on wyświetlać liczbę bohaterów występujących w danym odcinku.
 */
