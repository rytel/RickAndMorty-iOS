//
//  EpisodesSection.swift
//  RickAndMorty
//

import SwiftUI

struct EpisodesSection: View {
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

struct EpisodeRow: View {
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
