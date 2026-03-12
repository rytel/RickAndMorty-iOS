//
//  CharacterList.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import SwiftUI

struct CharacterList: View {
    let characters: [Character]
    let isLoading: Bool
    let onSelect: (Character) -> Void
    let onScrolledAtEnd: () -> Void
    
    var body: some View {
        List {
            ForEach(characters, id: \.id) { character in
                CharacterRow(character: character)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(character)
                    }
                    .onAppear {
                        if character == characters.last {
                            onScrolledAtEnd()
                        }
                    }
            }
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
