//
//  EvolutionChainAPI.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation

class EvolutionChainAPI: Codable {
    let chain: EvolutionApi
}

class EvolutionApi: Codable {
    let species: NameUrl
    let evolves_to: [EvolutionApi]
}
