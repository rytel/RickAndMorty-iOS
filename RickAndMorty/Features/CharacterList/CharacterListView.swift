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

// MARK: - Subviews

private struct InitialStateView: View {
    let onDownload: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Press button to load the character list")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Button(action: onDownload) {
                Text("Download characters")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
    }
}

private struct CharacterList: View {
    let characters: [Character]
    let onSelect: (Character) -> Void
    
    var body: some View {
        List {
            ForEach(characters, id: \.id) { character in
                CharacterRow(character: character)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(character)
                    }
            }
        }
    }
}

private struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                Text(character.status)
                    .font(.subheadline)
                    .foregroundColor(character.status == "Alive" ? .green : (character.status == "Dead" ? .red : .secondary))
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
