//
//  CachedAsyncImage.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 12/03/2026.
//

import SwiftUI
import ComposableArchitecture

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var loadingTask: Task<Void, Never>?
    
    @Dependency(\.imageClient) var imageClient
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
                    .onDisappear {
                        loadingTask?.cancel()
                        loadingTask = nil
                    }
            }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        loadingTask?.cancel()
        loadingTask = Task {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                
                let fetchedImage = try await imageClient.image(url)
                
                if !Task.isCancelled {
                    await MainActor.run {
                        self.image = fetchedImage
                    }
                }
            } catch {
                // Task was cancelled or network error
            }
        }
    }
}
