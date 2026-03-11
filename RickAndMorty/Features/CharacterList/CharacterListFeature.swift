//
//  CharacterListFeature.swift
//  RickAndMorty
//
//  Created by Rafal Rytel on 11/03/2026.
//

import ComposableArchitecture

@Reducer
struct CharacterListFeature {
    @ObservableState
    struct State: Equatable {
        var isShowingInstructions: Bool = true
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
                return .none
            case .cleanList:
                return .none
            case .loadCharacters:
                return .none
            case let .charactersLoaded(result):
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
