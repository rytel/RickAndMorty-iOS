//
//  CharacterListFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CharacterListFeature {
    @ObservableState
    struct State: Equatable {
        var isShowingInstructions: Bool = true
        var characters: [Character] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case hideTip
        case cleanList
        case loadCharacters
        case charactersLoaded(Result<[Character], Error>)
        case selectCharacter(Character)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .hideTip:
                state.isShowingInstructions = false
                return .none
                
            case .cleanList:
                state.isShowingInstructions = true
                state.characters = []
                return .none
                
            case .loadCharacters:
                state.isLoading = true
                state.isShowingInstructions = false
                return .run { send in
                    do {
                        let url = try await URLBuilder().allCharacters()
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let response = try JSONDecoder().decode(PaginatedResponse<Character>.self, from: data)
                        await send(.charactersLoaded(.success(response.results)))
                    } catch {
                        await send(.charactersLoaded(.failure(error)))
                    }
                }
                
            case let .charactersLoaded(.success(characters)):
                state.isLoading = false
                state.characters = characters
                return .none
                
            case let .charactersLoaded(.failure(error)):
                state.isLoading = false
                //handle error
                return .none
                
            case let .selectCharacter(character):
                return .none
            }
        }
    }
}

/*
 CharactersListView odpowiada za wczytywanie i prezentowanie listy bohaterów
 serialu „Rick and Morty”. Na samym początku widok powinien prezentować stan
 początkowy składający się z instrukcji tekstowej mówiącej użytkownikowi co trzeba
 zrobić, żeby wczytać listę bohaterów, oraz przycisku służącego do wczytania tej listy.
 Przykładowy tekst instrukcji została zamieszczony na końcu tego dokumentu, istnieje
 możliwość użycia dowolnego innego w celu lepszej estetyki aplikacji.
 CharactersListView niezależnie od wyświetlanej wartości powinien posiadać widoczny przycisk powodujący
 powrót do stanu początkowego widoku (schowanie listy, wyświetlenie instrukcji wraz z
 przyciskiem do wczytania bohaterów).
 Po naciśnięciu na dowolny element listy zawartej w CharactersListView,
 powinniśmy zostać przekierowani do CharacterDetailsView.
 */
