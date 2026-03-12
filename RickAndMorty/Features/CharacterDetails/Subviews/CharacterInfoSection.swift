//
//  CharacterInfoSection.swift
//  RickAndMorty
//

import SwiftUI

struct CharacterInfoSection: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Information")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Status", value: character.status, valueColor: statusColor)
                InfoRow(label: "Gender", value: character.gender)
                InfoRow(label: "Origin", value: character.origin.name)
                InfoRow(label: "Location", value: character.location.name)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var statusColor: Color {
        switch character.status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .primary
        }
    }
}
