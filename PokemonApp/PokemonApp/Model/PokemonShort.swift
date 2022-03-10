//
//  PokemonShort.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation

class PokemonShort: Codable {
    let name: String
    let url: String
    var id: String {
        let sub = self.url.split(separator: "/").last
        if let corr = sub {
            return String(corr)
        } else {
            return "na"
        }
    }
    
    var pokemonSpriteUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
