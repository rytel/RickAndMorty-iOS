//
//  CharacterDetailsFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture

@Reducer
struct CharacterDetailsFeature {
    @ObservableState
    struct State: Equatable {
        
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
 Na tym ekranie powinny
 zostać zaprezentowane następujące informacje:
 
 ⁃ Name
 ⁃ Status
 ⁃ Gender
 ⁃ Origin
 ⁃ Location
 ⁃ Image
 
 Pod wyżej wymienionymi informacjami, powinna znajdować się lista odcinków, w
 których wystąpił dany bohater. Odcinki powinny być zaprezentowane w formie tekstu
 „Odcinek <numer odcinka>”.
 
 Po naciśnięciu na wybrany odcinek jesteśmy przekierowani do ekranu
 EpisodeDetailsView
 */
