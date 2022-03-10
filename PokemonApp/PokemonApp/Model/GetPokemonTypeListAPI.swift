//
//  GetPokemonTypeListAPI.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation

class GetPokemonTypeListAPI: Codable {
    let pokemon: [PokemonTypeAPI]
}

class PokemonTypeAPI: Codable {
    let pokemon: PokemonShort
    let slot: Int
}
