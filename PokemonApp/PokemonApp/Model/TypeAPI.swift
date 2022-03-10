//
//  TypeAPI.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation

class TypeAPI: Codable {
    
    let damage_relations: TypeRelationAPI
    
}

class TypeRelationAPI: Codable {
    
    let double_damage_from: [NameUrl]
    let double_damage_to: [NameUrl]
    let half_damage_from: [NameUrl]
    let half_damage_to: [NameUrl]
    let no_damage_from: [NameUrl]
    let no_damage_to: [NameUrl]
}
