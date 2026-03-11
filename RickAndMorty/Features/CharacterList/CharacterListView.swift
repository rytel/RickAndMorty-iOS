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
                        initialStateView
                    } else {
                        characterList
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
                .background(
                    WithPerceptionTracking {
                        if let detailsStore = store.scope(state: \.destination?.details, action: \.destination.details) {
                            NavigationLink(
                                destination: CharacterDetailsView(store: detailsStore),
                                isActive: Binding(
                                    get: { true },
                                    set: { active in
                                        if !active { store.send(.destination(.dismiss)) }
                                    }
                                )
                            ) {
                                EmptyView()
                            }
                        }
                    }
                )
            }
        }
    }
    
    private var initialStateView: some View {
        VStack(spacing: 20) {
            Text("Press button to load the character list")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Button(action: {
                store.send(.loadCharacters)
            }) {
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
    
    private var characterList: some View {
        List {
            ForEach(store.characters, id: \.id) { character in
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
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.selectCharacter(character))
                }
            }
        }
    }
}

#Preview {
    CharacterListView(
        store: Store(initialState: CharacterListFeature.State()) {
            CharacterListFeature()
        }
    )
}
