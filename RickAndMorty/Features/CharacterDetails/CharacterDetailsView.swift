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
                    AsyncImage(url: URL(string: store.character.image)) { image in
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        infoRow(label: "Name", value: store.character.name)
                        infoRow(label: "Status", value: store.character.status)
                        infoRow(label: "Gender", value: store.character.gender)
                        infoRow(label: "Origin", value: store.character.origin.name)
                        infoRow(label: "Location", value: store.character.location.name)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Episodes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if store.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(store.episodes, id: \.id) { episode in
                                Button(action: {
                                    store.send(.selectEpisode(episode))
                                }) {
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
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(store.character.name)
            .onAppear {
                store.send(.onAppear)
            }
            
        }
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
            Text(value)
            Spacer()
        }
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
