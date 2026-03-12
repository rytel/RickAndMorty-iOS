//
//  RootFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 09/03/2026.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var characterList = CharacterListFeature.State()
    }
    
    enum Action {
        case characterList(CharacterListFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.characterList, action: \.characterList) {
            CharacterListFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
}

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        CharacterListView(
            store: store.scope(state: \.characterList, action: \.characterList)
        )
    }
}
