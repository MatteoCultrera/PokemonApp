//
//  Filter.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation

enum Filter {
    
    case none
    case type(PokemonType)
    case generation(PokemonGeneration)
    
    func getUrl() -> String {
        switch self {
        case .none:
            return "https://pokeapi.co/api/v2/pokemon/"
        case .type(let pokemonType):
            return "https://pokeapi.co/api/v2/type/\(pokemonType.getId())"
        case .generation(let pokemonGeneration):
            return "https://pokeapi.co/api/v2/generation/\(pokemonGeneration.getId())/"
        }
    }
    
}
