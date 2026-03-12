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
                item: $store.scope(state: \.destination?.episodeDetails, action: \.destination.episodeDetails)
            ) { episodeStore in
                episodeDetailsSheet(for: episodeStore)
            }
        }
    }
    
    @ViewBuilder
    private var episodesSection: some View {
        if store.isLoading {
            ProgressView("Loading episodes...")
                .frame(maxWidth: .infinity)
                .padding()
        } else if !store.episodes.isEmpty {
            EpisodesSection(
                episodes: store.episodes,
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

// MARK: - Subviews

private struct CharacterHeaderView: View {
    let character: Character
    
    var body: some View {
        AsyncImage(url: URL(string: character.image)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
        } placeholder: {
            Color.gray.opacity(0.1)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct CharacterInfoSection: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Information")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Status", value: character.status, valueColor: statusColor)
                InfoRow(label: "Gender", value: character.gender)
                InfoRow(label: "Origin", value: character.origin.name)
                InfoRow(label: "Location", value: character.location.name)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var statusColor: Color {
        switch character.status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .primary
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(valueColor)
        }
    }
}

private struct EpisodesSection: View {
    let episodes: [Episode]
    let onSelect: (Episode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episodes")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(episodes, id: \.id) { episode in
                EpisodeRow(episode: episode)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(episode)
                    }
            }
        }
    }
}

private struct EpisodeRow: View {
    let episode: Episode
    
    var body: some View {
        HStack {
            Text("Episode \(episode.id)")
                .font(.headline)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
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
