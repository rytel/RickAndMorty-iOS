//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 09/03/2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            CharacterListView(
                store: Store(initialState: CharacterListFeature.State()) {
                    CharacterListFeature()
                }
            )
        }
    }
}

