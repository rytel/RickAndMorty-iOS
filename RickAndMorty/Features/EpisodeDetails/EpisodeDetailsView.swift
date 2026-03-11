//
//  EpisodeDetailsView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {
    let store: StoreOf<EpisodeDetailsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    EpisodeHeaderCard(episode: store.episode)
                }
                .padding()
            }
            .navigationTitle("Episode Details")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// MARK: - Subviews

private struct EpisodeHeaderCard: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(episode.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                InfoLabel(icon: "tv", label: "Episode", value: episode.episode)
                InfoLabel(icon: "calendar", label: "Air Date", value: episode.air_date)
                InfoLabel(icon: "person.3", label: "Characters count", value: "\(episode.characters.count)")
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private struct InfoLabel: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        EpisodeDetailsView(
            store: Store(
                initialState: EpisodeDetailsFeature.State(
                    episode: Episode(
                        id: 1,
                        name: "Title",
                        air_date: "01.01.2026",
                        episode: "S01E01",
                        characters: ["https://rickandmortyapi.com/api/character/1"]
                    )
                )
            ) {
                EpisodeDetailsFeature()
            }
        )
    }
}
