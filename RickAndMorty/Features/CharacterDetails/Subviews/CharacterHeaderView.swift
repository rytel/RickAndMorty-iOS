//
//  CharacterHeaderView.swift
//  RickAndMorty
//

import SwiftUI

struct CharacterHeaderView: View {
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
