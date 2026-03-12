//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CharacterListView: View {
    @Perception.Bindable var store: StoreOf<CharacterListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationView {
                VStack {
                    if store.isLoading {
                        ProgressView()
                    } else if let errorMessage = store.errorMessage {
                        ErrorView(message: errorMessage, onRetry: { store.send(.retry) })
                    } else if store.isShowingInstructions {
                        InitialStateView(onDownload: { store.send(.loadCharacters) })
                    } else {
                        CharacterList(
                            characters: store.characters,
                            onSelect: { store.send(.selectCharacter($0)) }
                        )
                    }
                }
                .navigationTitle("Characters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Reset") {
                            store.send(.cleanList)
                        }
                    }
                }
                .background(navigationLink)
            }
        }
    }
    
    @ViewBuilder
    private var navigationLink: some View {
        WithPerceptionTracking {
            NavigationLink(
                destination: WithPerceptionTracking {
                    if let detailsStore = store.scope(state: \.destination?.details, action: \.destination.details) {
                        CharacterDetailsView(store: detailsStore)
                    }
                },
                isActive: Binding(
                    get: { store.destination != nil },
                    set: { active in
                        if !active && store.destination != nil {
                            store.send(.destination(.dismiss))
                        }
                    }
                )
            ) {
                EmptyView()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CharacterListView(
        store: Store(initialState: CharacterListFeature.State()) {
            CharacterListFeature()
        }
    )
}
