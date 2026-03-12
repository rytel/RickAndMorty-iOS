//
//  CharacterList.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import SwiftUI

struct CharacterList: View {
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
