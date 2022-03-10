//
//  GetPokemonSpecieAPI.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import Foundation

class GetPokemonSpecieAPI: Codable {
    
    let flavor_text_entries: [FlavorText]
    let evolution_chain: Url?
    
}

class Url: Codable {
    let url: String
}

class FlavorText: Codable {
    let flavor_text: String
    let language: NameUrl
    let version: NameUrl
}
