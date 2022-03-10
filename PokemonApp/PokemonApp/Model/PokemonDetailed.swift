//
//  PokemonDetailed.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation
import UIKit

class PokemonDetailed {
    
    public enum State {
        case onlyName
        case pokemon
        case full
    }
    
    let name: String
    let infoUrl: String
    let pokemon: Pokemon
    public var imageSet: PokemonImageSet = PokemonImageSet()
    var state: State
    var pokedexDescription: String?
    var evolutionTree: PokemonEvolutionTree
    
    init(name: String, infoUrl: String) {
        self.name = name
        self.infoUrl = infoUrl
        self.state = .onlyName
        self.pokemon = Pokemon(name: name, infoUrl: infoUrl)
        self.evolutionTree = PokemonEvolutionTree(root: Node(value: PokemonShort(name: self.name, url: self.infoUrl)))
    }
    
    init(pokemon: Pokemon) {
        self.name = pokemon.name
        self.infoUrl = pokemon.infoUrl
        self.state = .pokemon
        self.pokemon = pokemon
        self.evolutionTree = PokemonEvolutionTree(root: Node(value: PokemonShort(name: self.name, url: self.infoUrl)))
    }
    
    public func updatePokemon(with api: PokemonApiPokemon) {
        pokemon.updateInfo(with: api)
    }
    
    public func updatePokemon(with api: GetPokemonSpecieAPI) {
        
        self.pokedexDescription = api.flavor_text_entries.first(where: {$0.language.name == "en"})?.flavor_text.replacingOccurrences(of: "\\s", with: " ", options: .regularExpression)
    }
    
    public func updatePokemonTree(with api: EvolutionChainAPI) {
        
        self.evolutionTree = PokemonEvolutionTree(chain: api)
    }
    
    public func getPreviousEvolutions() -> [PokemonShort] {
        
        guard let shortSub = name.split(separator: "-").first else {
            return []
        }
        
        return self.evolutionTree.getPreviousEvolutions(from: String(shortSub))
    }
    
    public func getNextEvolutions() -> [PokemonShort] {
        
        guard let shortSub = name.split(separator: "-").first else {
            return []
        }
        
        return self.evolutionTree.getNextEvolutions(from: String(shortSub))
    }
    
}

struct PokemonImageSet {
    
    var defaultImage: UIImage?
    var defaultFemale: UIImage?
    var shinyImage: UIImage?
    var shinyFemale: UIImage?
    var officialArtwork: UIImage?
    var spriteImage: UIImage?
    
    enum ImageType {
        case male
        case female
        case maleShiny
        case femaleShiny
        case artwork
        case sprite
    }
    
    init() {
        self.defaultImage = nil
        self.defaultFemale = nil
        self.shinyImage = nil
        self.shinyFemale = nil
        self.officialArtwork = nil
        self.spriteImage = nil
    }
    
    mutating func setImage(image: UIImage?, for type: ImageType) {
        switch type {
        case .male:
            self.defaultImage = image
        case .female:
            self.defaultFemale = image
        case .maleShiny:
            self.shinyImage = image
        case .femaleShiny:
            self.shinyFemale = image
        case .sprite:
            self.spriteImage = image
        case .artwork:
            self.officialArtwork = image
        }
    }
    
    func hasImages() -> Bool {
        return getDefaultImage() != nil
    }
    
    func getDefaultImage() -> UIImage? {
        return defaultImage ?? defaultFemale ?? shinyImage ?? shinyFemale ?? officialArtwork ?? spriteImage
    }
    
    
}
