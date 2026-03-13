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
    @State private var hasError: Bool = false
    
    @Dependency(\.imageClient) var imageClient
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        
        if let url = url, let cached = ImageCache.shared.get(for: url) {
            _image = State(initialValue: cached)
        }
    }
    
    var body: some View {
        ZStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        loadImage()
                    }
                    .onAppear {
                        loadImage()
                    }
                
                if hasError {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                        Text("Retry")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .onDisappear {
            loadingTask?.cancel()
            loadingTask = nil
        }
    }
    
    private func loadImage() {
        guard let url = url, image == nil else { return }
        
        if let cached = ImageCache.shared.get(for: url) {
            self.image = cached
            self.hasError = false
            return
        }
        
        loadingTask?.cancel()
        hasError = false
        
        loadingTask = Task {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                
                let fetchedImage = try await imageClient.image(url)
                
                if !Task.isCancelled {
                    await MainActor.run {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.image = fetchedImage
                            self.hasError = false
                        }
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.hasError = true
                    }
                }
            }
        }
    }
}
