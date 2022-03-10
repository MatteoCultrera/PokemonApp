//
//  GetPokemonListAPI.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation

class GetPokemonListAPI: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    
    let results: [PokemonShort]
    
    
}
