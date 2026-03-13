//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    @Perception.Bindable var store: StoreOf<CharacterDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CharacterHeaderView(character: store.character)
                    CharacterInfoSection(character: store.character)
                    episodesSection
                }
                .padding()
            }
            .navigationTitle(store.character.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { store.send(.onAppear) }
            .sheet(
                store: store.scope(state: \.$destination.episodeDetails, action: \.destination.episodeDetails)
            ) { episodeStore in
                episodeDetailsSheet(for: episodeStore)
            }
        }
    }
    
    @ViewBuilder
    private var episodesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Episodes")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if store.isLoading {
                    Spacer()
                    ProgressView()
                }
            }
            
            EpisodesSection(
                episodeIDs: store.episodeIDs,
                onSelect: { store.send(.selectEpisode($0)) }
            )
        }
    }
    
    private func episodeDetailsSheet(for store: StoreOf<EpisodeDetailsFeature>) -> some View {
        NavigationView {
            EpisodeDetailsView(store: store)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            self.store.send(.destination(.dismiss))
                        }
                    }
                }
        }
    }
}

// MARK: - Preview

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsFeature.State(
                character: Character(
                    id: 1,
                    name: "Rick Sanchez",
                    status: "Alive",
                    gender: "Men",
                    origin: Origin(name: "origin name", url: ""),
                    location: Location(name: "location name", url: ""),
                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    episode: ["https://rickandmortyapi.com/api/episode/1",
                              "https://rickandmortyapi.com/api/episode/2"]
                )
            )
        ) {
            CharacterDetailsFeature()
        }
    )
}
