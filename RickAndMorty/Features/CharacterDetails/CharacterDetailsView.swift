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
            
            if let errorMessage = store.errorMessage {
                ErrorSection(message: errorMessage, onRetry: { store.send(.retry) })
            } else {
                EpisodesSection(
                    episodeIDs: store.episodeIDs,
                    onSelect: { store.send(.selectEpisode($0)) }
                )
            }
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
        CachedAsyncImage(url: URL(string: character.image)) { image in
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
    let episodeIDs: [Int]
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(episodeIDs, id: \.self) { id in
                EpisodeRow(id: id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(id)
                    }
            }
        }
    }
}

private struct EpisodeRow: View {
    let id: Int
    
    var body: some View {
        HStack {
            Text("Episode \(id)")
                .font(.headline)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

private struct ErrorSection: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Failed to load episode details")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                Label("Clear Error", systemImage: "xmark.circle")
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
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
