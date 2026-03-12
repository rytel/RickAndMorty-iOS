//
//  InitialStateView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import SwiftUI

struct InitialStateView: View {
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
