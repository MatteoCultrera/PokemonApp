//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

protocol ImageRepresentable {
    func getImage() -> UIImage?
}

protocol ColorRepresentable {
    func getColor() -> UIColor
}

protocol TextRepresentable {
    func getText() -> String
}

class Pokemon {
    
    enum State {
        case shimmer
        case configured
        case error
    }
    
    let name: String
    let infoUrl: String
    var types: [Types]
    var stats: [Stat]
    var imageURL: String?
    var speciesURL: String?
    
    var maleUrl: String? = nil
    var femaleUrl: String? = nil
    var maleShinyUrl: String? = nil
    var femaleShinyUrl: String? = nil
    var sprite: String? = nil
    var artwork: String? = nil
    
    public var state: State
    
    
    init(name: String, infoUrl: String) {
        self.name = name
        self.infoUrl = infoUrl
        self.state = .shimmer
        self.types = []
        self.stats = []
        self.imageURL = nil
    }
    
    func updateInfo(with pokemon: PokemonApiPokemon) {
        self.state = .configured
        if let types = pokemon.types {
            for type in types {
                self.types.append(type)
            }
        }
        self.imageURL = pokemon.sprites?.getSprite()
        self.maleUrl = pokemon.sprites?.other?.home?.front_default
        self.femaleUrl = pokemon.sprites?.other?.home?.front_female
        self.maleShinyUrl = pokemon.sprites?.other?.home?.front_shiny
        self.femaleShinyUrl = pokemon.sprites?.other?.home?.front_shiny_female
        self.artwork = pokemon.sprites?.other?.officialArtwork?.front_default
        self.sprite = pokemon.sprites?.front_default
        self.speciesURL = pokemon.species?.url
        
        for stat in pokemon.stats {
            self.stats.append(Stat(from: stat))
        }
    }
    
    func setError() {
        self.state = .error
    }
}

class PokemonApiPokemon: Codable {
    let abilities: [Ability]?
    let base_experience: Int?
    let forms: [NameUrl]?
    let height: Int?
    let id: Int?
    let is_default: Bool?
    let name: String
    let order: Int?
    let species: NameUrl?
    let sprites: Sprites?
    let types: [Types]?
    let weight: Int?
    let stats: [StatApi]
}

class StatApi: Codable {
    
    let base_stat: Int
    let effort: Int
    let stat: NameUrl
    
}

class Ability: Codable {
    let ability: NameUrl
    let isHidden: Bool?
    let slot: Int
}

class NameUrl: Codable {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

class Sprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    
    let other: OtherSprites?
    
    func getSprite() -> String? {
        return front_default ?? front_female ?? front_shiny ?? front_shiny_female
    }
    
    func getHighResImage() -> String? {
        return other?.home?.front_default ?? other?.home?.front_female ?? front_default ?? front_female ?? front_shiny ?? front_shiny_female
    }
}

class OtherSprites: Codable {
    let dreamWorld: Sprites?
    let home: Sprites?
    let officialArtwork: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case home = "home"
        case officialArtwork = "official-artwork"
    }
}

class Types: Codable {
    let slot: Int
    let type: NameUrl
    let pokemonType: PokemonType
    
    init(slot: Int, type: NameUrl){
        self.slot = slot
        self.type = type
        self.pokemonType = PokemonType(rawValue: type.name) ?? .normal
    }
    
    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        slot = try container.decode(Int.self, forKey: .slot)
        type = try container.decode(NameUrl.self, forKey: .type)
        self.pokemonType = PokemonType(rawValue: type.name) ?? .normal
    }
}

enum Stat: ColorRepresentable, TextRepresentable {
    
    case hp(value: Int)
    case attack(value: Int)
    case defense(value: Int)
    case specialAttack(value: Int)
    case specialDefense(value: Int)
    case speed(value: Int)
    
    func getColor() -> UIColor {
        switch self {
        case .hp(_):
            return UIColor(rgb: 0x3BCD5B)
        case .attack(_), .specialAttack(_):
            return UIColor(rgb: 0xED674D)
        case .defense(_), .specialDefense(_):
            return UIColor(rgb: 0x6DD3FF)
        case .speed(_):
            return UIColor(rgb: 0xBE7DFF)
        }
    }
    
    func getText() -> String {
        switch self {
        case .hp(_):
            return "Hp"
        case .attack(_):
            return "Attack"
        case .defense(_):
            return "Defense"
        case .specialAttack(_):
            return "Special Attack"
        case .specialDefense(_):
            return "Special Defense"
        case .speed(_):
            return "Speed"
        }
    }
    
    func getStat() -> Int {
        switch self {
        case .hp(let value):
            return value
        case .attack(let value):
            return value
        case .defense(let value):
            return value
        case .specialAttack(let value):
            return value
        case .specialDefense(let value):
            return value
        case .speed(let value):
            return value
        }
    }
    
    init(from stat: StatApi) {
        
        switch stat.stat.name {
        case "hp":
            self = .hp(value: stat.base_stat)
        case "attack":
            self = .attack(value: stat.base_stat)
        case "defense":
            self = .defense(value: stat.base_stat)
        case "special-attack":
            self = .specialAttack(value: stat.base_stat)
        case "special-defense":
            self = .specialDefense(value: stat.base_stat)
        case "speed":
            self = .speed(value: stat.base_stat)
        default:
            self = .hp(value: 0)
        }
        
        
    }
    
}

enum ImageVariants: ImageRepresentable, ColorRepresentable, TextRepresentable, CaseIterable {
    
    func getText() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .maleShiny:
            return "Male Shiny"
        case .femaleShiny:
            return "Female Shiny"
        case .sprite:
            return "Sprite"
        case .originalArtwork:
            return "Artwork"
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .male:
            return UIImage(named: "male_icon")
        case .female:
            return UIImage(named: "female")
        case .maleShiny:
           return UIImage(named: "male_shiny")
        case .femaleShiny:
            return UIImage(named: "female_shiny")
        case .sprite:
            return UIImage(named: "sprite_icon")
        case .originalArtwork:
            return UIImage(named: "artwork")
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case .male:
            return UIColor(rgb: 0x3692DC)
        case .female:
            return UIColor(rgb: 0xFB89EB)
        case .maleShiny:
            return UIColor(rgb: 0xFBD100)
        case .femaleShiny:
            return UIColor(rgb: 0xFBD100)
        case .sprite:
            return UIColor(rgb: 0x38BF4B)
        case .originalArtwork:
            return UIColor(rgb: 0xB567CE)
        }
    }
    
    
    case male
    case female
    case maleShiny
    case femaleShiny
    case originalArtwork
    case sprite
    
}

enum PokemonGeneration: String, ImageRepresentable, ColorRepresentable, TextRepresentable, CaseIterable {
    
    func getColor() -> UIColor {
        return UIColor.red
    }
    
    func getText() -> String {
        rawValue
    }
    
    case gen1 = "generation-i"
    case gen2 = "generation-ii"
    case gen3 = "generation-iii"
    case gen4 = "generation-iv"
    case gen5 = "generation-v"
    case gen6 = "generation-vi"
    case gen7 = "generation-vii"
    case gen8 = "generation-viii"
    
    func getImage() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    func getId() -> String {
        switch self {
        case .gen1:
            return "1"
        case .gen2:
            return "2"
        case .gen3:
            return "3"
        case .gen4:
            return "4"
        case .gen5:
            return "5"
        case .gen6:
            return "6"
        case .gen7:
            return "7"
        case .gen8:
            return "8"
        }
    }
    
    init(id: String) {
        switch id {
        case "1":
            self = .gen1
        case "2":
            self = .gen2
        case "3":
            self = .gen3
        case "4":
            self = .gen4
        case "5":
            self = .gen5
        case "6":
            self = .gen6
        case "7":
            self = .gen7
        case "8":
            self = .gen8
        default:
            self = .gen1
        }
    }
    
}

enum PokemonType: String, ImageRepresentable, ColorRepresentable, TextRepresentable, CaseIterable {
    
    case bug = "bug"
    case dark = "dark"
    case dragon = "dragon"
    case electric = "electric"
    case fairy = "fairy"
    case fighting = "fighting"
    case fire = "fire"
    case flying = "flying"
    case ghost = "ghost"
    case grass = "grass"
    case ground = "ground"
    case ice = "ice"
    case normal = "normal"
    case poison = "poison"
    case psychic = "psychic"
    case rock = "rock"
    case steel = "steel"
    case water = "water"
    
    func getColor() -> UIColor {
        switch self {
        case .bug:
            return UIColor(rgb: 0x83C300)
        case .dark:
            return UIColor(rgb: 0x5B5466)
        case .dragon:
            return UIColor(rgb: 0x006FC9)
        case .electric:
            return UIColor(rgb: 0xFBD100)
        case .fairy:
            return UIColor(rgb: 0xFB89EB)
        case .fighting:
            return UIColor(rgb: 0xE0306A)
        case .fire:
            return UIColor(rgb: 0xFF9741)
        case .flying:
            return UIColor(rgb: 0x89AAE3)
        case .ghost:
            return UIColor(rgb: 0x4C6AB2)
        case .grass:
            return UIColor(rgb: 0x38BF4B)
        case .ground:
            return UIColor(rgb: 0xE87236)
        case .ice:
            return UIColor(rgb: 0x4CD1C0)
        case .normal:
            return UIColor(rgb: 0x919AA2)
        case .poison:
            return UIColor(rgb: 0xB567CE)
        case .psychic:
            return UIColor(rgb: 0xFF6675)
        case .rock:
            return UIColor(rgb: 0xC8B686)
        case .steel:
            return UIColor(rgb: 0x5A8EA2)
        case .water:
            return UIColor(rgb: 0x3692DC)
        }
    }
    
    func getText() -> String {
        return rawValue
    }
    func getImage() -> UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    func getId() -> String {
        switch self {
        case .bug:
            return "7"
        case .dark:
            return "17"
        case .dragon:
            return "16"
        case .electric:
            return "13"
        case .fairy:
            return "18"
        case .fighting:
            return "2"
        case .fire:
            return "10"
        case .flying:
            return "3"
        case .ghost:
            return "8"
        case .grass:
            return "12"
        case .ground:
            return "5"
        case .ice:
            return "15"
        case .normal:
            return "1"
        case .poison:
            return "4"
        case .psychic:
            return "14"
        case .rock:
            return "6"
        case .steel:
            return "9"
        case .water:
            return "11"
        }
    }
    
    init(id: String) {
        switch id {
        case "7":
            self = .bug
        case "17":
            self = .dark
        case "16":
            self = .dragon
        case "13":
            self = .electric
        case "18":
            self = .fairy
        case "2":
            self = .fighting
        case "10":
            self = .fire
        case "3":
            self = .flying
        case "8":
            self = .ghost
        case "12":
            self = .grass
        case "5":
            self = .ground
        case "15":
            self = .ice
        case "1":
            self = .normal
        case "4":
            self = .poison
        case "14":
            self = .psychic
        case "6":
            self = .rock
        case "9":
            self = .steel
        case "11":
            self = .water
        default:
            self = .normal
        }
    }
}

