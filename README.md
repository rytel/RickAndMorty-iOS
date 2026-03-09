# Rick and Mort - Recruitment Task

This is a simple iOS application built with SwiftUI that fetches and displays data from the [Rick and Morty API](https://rickandmortyapi.com/).

## Features

- **Character List:** Browse through the characters of the Rick and Morty series.
- **Character Details:** View detailed information about a specific character, including their status, gender, origin, location, and the list of episodes they appeared in.
- **Episode Details:** See information about a specific episode, such as its name, air date, episode code, and the count of characters featured in it.
- **Async/Await:** All networking is handled using modern Swift concurrency.
- **SwiftUI:** The entire user interface is built using SwiftUI.

## Architecture

The project is designed with modularity and testability in mind, following modern iOS development practices.

- **UI Framework:** SwiftUI
- **Networking:** Custom API Client using `Async/Await`.
- **Minimum Deployment Target:** iOS 15.0

## Requirements

- Xcode 13.0 or later
- iOS 15.0+

## Project Structure

The application consists of three main views:

1.  **CharactersListView:** The entry point of the app.
    - Features an initial state with instructions and a load button.
    - Displays a list of Rick and Morty characters.
    - Includes a reset button to return to the initial state.
2.  **CharacterDetailsView:** Shows comprehensive details for a selected character.
    - Displays Name, Status, Gender, Origin, Location, and Image.
    - Lists episodes the character appeared in.
3.  **EpisodeDetailsView:** Provides details for a specific episode.
    - Displays Name, Air Date, and Episode Code.
    - Shows the total number of characters in the episode.

## Technical Details

- **API Integration:** Uses the [Rick and Morty REST API](https://rickandmortyapi.com/documentation/#rest).
- **UX Best Practices:** Includes handling for different states such as loading, errors, and empty states.

## Future Improvements (Nice to Have)

- [ ] Implement The Composable Architecture (TCA).
- [ ] Add a "Favorites" feature to highlight preferred characters.
- [ ] Implement Dependency Injection for better testability.
- [ ] Enhance UI/UX with custom styling and animations.
