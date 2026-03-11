//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 09/03/2026.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        
    }
}

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        Text("HI")
    }
}
