//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CharacterListView: View {
    var store: StoreOf<CharacterListFeature>
    
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
                .navigationTitle("Character list")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Reset") {
                            store.send(.cleanList)
                        }
                    }
                }
            }
        }
    }
    
    private var initialStateView: some View {
        WithPerceptionTracking {
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
    }
    
    private var characterList: some View {
        WithPerceptionTracking {
            List {
                ForEach(store.characters, id: \.id) { character in
                    Text(character.name)
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
