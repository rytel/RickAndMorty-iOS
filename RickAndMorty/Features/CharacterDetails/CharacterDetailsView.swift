//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    let store: StoreOf<CharacterDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(spacing: 20) {
                    CharacterHeaderView(imageUrl: store.character.image)
                    CharacterInfoSection(character: store.character)
                    EpisodesSection(
                        isLoading: store.isLoading,
                        episodes: store.episodes,
                        onSelect: { store.send(.selectEpisode($0)) }
                    )
                }
            }
            .navigationTitle(store.character.name)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

// MARK: - Subviews
private struct CharacterHeaderView: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .cornerRadius(12)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 200, height: 200)
                .cornerRadius(12)
                .overlay(ProgressView())
        }
    }
}

private struct CharacterInfoSection: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            InfoRow(label: "Name", value: character.name)
            InfoRow(label: "Status", value: character.status)
            InfoRow(label: "Gender", value: character.gender)
            InfoRow(label: "Origin", value: character.origin.name)
            InfoRow(label: "Location", value: character.location.name)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
            Text(value)
            Spacer()
        }
    }
}

private struct EpisodesSection: View {
    let isLoading: Bool
    let episodes: [Episode]
    let onSelect: (Episode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Episodes")
                .font(.headline)
                .padding(.horizontal)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(episodes, id: \.id) { episode in
                        EpisodeRow(episode: episode, onTap: { onSelect(episode) })
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct EpisodeRow: View {
    let episode: Episode
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("Odcinek \(episode.id)")
                Spacer()
                Text(episode.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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
