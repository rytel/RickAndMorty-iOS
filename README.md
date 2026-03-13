# Rick & Morty iOS App

A modern iOS application built with **SwiftUI** and **The Composable Architecture (TCA)**, showcasing characters and episodes from the Rick and Morty universe. 

## 🚀 Features

- **Character Explorer:** Browse a paginated list of characters with infinite scrolling.
- **Deep Details:** View comprehensive information about each character, including their status, origin, and last known location.
- **Episode Integration:** Access a list of episodes for each character, with the ability to view specific episode details in a sleek sheet.
- **Offline Resilience:** 
    - Full network error handling with user-friendly alerts.
    - **Smart Retry:** Distinct logic for retrying initial loads versus pagination.
    - **Advanced Image Caching:** Custom `CachedAsyncImage` component with instant memory-cache rendering and optimized network debouncing.

## 🛠 Tech Stack & Architecture

- **Language:** Swift 5.10+
- **UI Framework:** SwiftUI (Support for **iOS 15.0+**)
- **Architecture:** The Composable Architecture (TCA)
    - Unidirectional data flow.
    - State management using `@ObservableState`.
    - Modular feature design.
- **Networking:** `URLSession` with a custom `NetworkHelper` and `URLBuilder`.
- **Dependency Injection:** Powered by TCA's `@Dependency` system for maximum testability.

## 🏗 Key Engineering Decisions

- **URLBuilder:** Centralized point for constructing API endpoints, preventing hardcoded strings and ensuring consistency.
- **Dependency Decoupling:** API clients and helpers are registered as dependencies, allowing for easy mocking in tests.
- **Performance Optimization:** 
    - Parallel episode fetching using `withThrowingTaskGroup`.
    - Synchronous cache check for images to eliminate UI flickering during scrolling.
    - 0.3s network debounce for images to reduce server load.
- **UI/UX Consistency:** Systematic use of `AlertState` for consistent error communication and recovery.

## 📂 Project Structure

```text
RickAndMorty/
├── API/             # Networking interfaces and builders
├── App/             # App entry point and Root coordinator
├── Dependencies/    # TCA dependency registrations
├── Features/        # Functional modules (List, Details, Episode)
├── Model/           # Decodable entities and logic
└── UI/              # Shared UI components (CachedAsyncImage)
```

## 🧪 Testing

The project emphasizes reliability through comprehensive unit tests:
- **Feature Tests:** Verifying state transitions, pagination logic, and error handling cycles.
- **API Tests:** Mocking network responses to verify client robustness.
- **Model Tests:** Ensuring data transformations (like ID extraction) are error-free.
- **URL Tests:** Validating that the `URLBuilder` generates correct and safe paths.

### Running Tests
You can run the tests directly in Xcode (**Cmd+U**) or via CLI:
```bash
xcodebuild test -project RickAndMorty.xcodeproj -scheme RickAndMorty -destination 'platform=iOS Simulator,name=iPhone SE (2nd generation),OS=15.5'
```

---
*Created as a technical recruitment task.*
