//
//  TypesRelationManager.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation

class TypesRelationManager {
    
    static var singleton = TypesRelationManager()
    
    private var typeRelations = [PokemonType : TypeRelation]()
    
    
    public func setTypeRelations(
        for type: PokemonType,
        relations typeRelation: TypeRelation) {
           typeRelations[type] = typeRelation
        }
    
    public func getTypeRelations(for type: PokemonType) -> TypeRelation? {
        return typeRelations[type]
    }
    
    public func setTypeRelations(for type: PokemonType, with api: TypeAPI) {
        
        var doubleDamageFrom = [PokemonType]()
        
        api.damage_relations.double_damage_from.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                doubleDamageFrom.append(type)
            }
        })
        
        var doubleDamageTo = [PokemonType]()
        
        api.damage_relations.double_damage_to.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                doubleDamageTo.append(type)
            }
        })
        
        var halfDamageFrom = [PokemonType]()
        
        api.damage_relations.half_damage_from.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                halfDamageFrom.append(type)
            }
        })
        
        var halfDamageTo = [PokemonType]()
        
        api.damage_relations.half_damage_to.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                halfDamageTo.append(type)
            }
        })
        
        var noDamageFrom = [PokemonType]()
        
        api.damage_relations.no_damage_from.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                noDamageFrom.append(type)
            }
        })
        
        var noDamageTo = [PokemonType]()
        
        api.damage_relations.no_damage_to.forEach({ type in
            if let type = PokemonType(rawValue: type.name) {
                noDamageTo.append(type)
            }
        })
        
        
        let relations = TypeRelation(
            doubleDamageFrom: doubleDamageFrom,
            doubleDamageTo: doubleDamageTo,
            halfDamageFrom: halfDamageFrom,
            halfDamageTo: halfDamageTo,
            noDamageFrom: noDamageFrom,
            noDamageTo: noDamageTo)
        
        typeRelations[type] = relations
    }
    
}

struct TypeRelation {
    let doubleDamageFrom: [PokemonType]
    let doubleDamageTo: [PokemonType]
    let halfDamageFrom: [PokemonType]
    let halfDamageTo: [PokemonType]
    let noDamageFrom: [PokemonType]
    let noDamageTo: [PokemonType]
}
