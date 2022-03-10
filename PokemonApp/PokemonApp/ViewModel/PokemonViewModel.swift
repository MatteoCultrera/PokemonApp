//
//  PokemonViewModel.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation

class PokemonViewModel {
    
    private(set) var pokemonDetailed: PokemonDetailed
    
    public var hasImages: Bool {
        get {
            return pokemonDetailed.imageSet.hasImages()
        }
    }
    
    public var mainType: PokemonType {
        return self.pokemonDetailed.pokemon.types.first?.pokemonType ?? .normal
    }
    
    init(pokemon: Pokemon) {
        self.pokemonDetailed = PokemonDetailed(pokemon: pokemon)
    }
    
    init(name: String, url: String) {
        self.pokemonDetailed = PokemonDetailed(name: name, infoUrl: url)
    }
    
    
    
    public func completePokemonInfo(dataProvider: DataProvider = DataManager.shared,completion: @escaping () -> (), onError: @escaping () -> ()) {
        
        let group = DispatchGroup()
        
        switch pokemonDetailed.state {
        case .onlyName:
            
            dataProvider.getPokemonInfo(
                from: pokemonDetailed.infoUrl,
                onSuccess: {[weak self] pokemon in
                    guard let self = self else { return }
                    self.pokemonDetailed.updatePokemon(with: pokemon)
                    //Get all pokemon sprites
                    if let frontDefaultURL = self.pokemonDetailed.pokemon.maleUrl {
                        dataProvider.getPokemonImage(
                            from: frontDefaultURL,
                            onSuccess: {[weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .male)
                            },
                            onError: { },
                            dispatchGroup: group)
                    }
                    if let frontFemaleURL = self.pokemonDetailed.pokemon.femaleUrl {
                        dataProvider.getPokemonImage(
                            from: frontFemaleURL,
                            onSuccess: {[weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .female)
                            },
                            onError: { },
                            dispatchGroup: group)
                    }
                    if let frontShinyURL = self.pokemonDetailed.pokemon.maleShinyUrl {
                        dataProvider.getPokemonImage(
                            from: frontShinyURL,
                            onSuccess: {[weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .maleShiny)
                            },
                            onError: { },
                            dispatchGroup: group)
                    }
                    if let frontShinyFemaleURL = self.pokemonDetailed.pokemon.femaleShinyUrl {
                        dataProvider.getPokemonImage(
                            from: frontShinyFemaleURL,
                            onSuccess: {[weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .femaleShiny)
                            },
                            onError: { },
                            dispatchGroup: group)
                    }
                    if let artwork = self.pokemonDetailed.pokemon.artwork {
                        dataProvider.getPokemonImage(
                            from: artwork,
                            onSuccess: {[weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .artwork)
                            },
                            onError: { },
                            dispatchGroup: group)
                    }
                    if let sprite = self.pokemonDetailed.pokemon.sprite {
                        group.enter()
                        dataProvider.getCachedPokemonImage(
                            from: sprite,
                            completion: { [weak self] image in
                                guard let self = self else { return }
                                self.pokemonDetailed.imageSet.setImage(image: image, for: .sprite)
                                group.leave()
                            },
                            onError: {
                                group.leave()
                            })
                    }
                    //Get Pokemon Species info
                    var evolutionChainUrl: String? = nil
                    if let speciesURL = self.pokemonDetailed.pokemon.speciesURL {
                        group.enter()
                        dataProvider.getSpecieInfo(
                            from: speciesURL,
                            onSuccess: { specie in
                                self.pokemonDetailed.updatePokemon(with: specie)
                                evolutionChainUrl = specie.evolution_chain?.url
                                                                
                                //Get Evolution Chain info
                                if let evolutionChainUrl = evolutionChainUrl {
                                    
                                    dataProvider.getPokemonEvolutionChain(
                                        from: evolutionChainUrl,
                                        onSuccess: { chain in
                                            self.pokemonDetailed.updatePokemonTree(with: chain)
                                            group.leave()
                                        },
                                        onError: {
                                            group.leave()
                                        },
                                        cacheUsage: .cacheFirst,
                                        dispatchGroup: nil)
                                } else {
                                    group.leave()
                                }
                                
                            }, onError: {
                                group.leave()
                            },
                            cacheUsage: .cacheFirst,
                            dispatchGroup: nil)
                    }
                    
                    group.notify(queue: DispatchQueue.global()) {
                        completion()
                    }
                }, onError: {
                    //Calls error only if we are not able to show any info about the pokemon
                    onError()
                },
                cacheUsage: .cacheFirst,
                dispatchGroup: nil)
            break
        case .pokemon:
            
            //Get all pokemon sprites
            if let frontDefaultURL = self.pokemonDetailed.pokemon.maleUrl {
                dataProvider.getPokemonImage(
                    from: frontDefaultURL,
                    onSuccess: {[weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .male)
                    },
                    onError: { },
                    dispatchGroup: group)
            }
            if let frontFemaleURL = pokemonDetailed.pokemon.femaleUrl {
                dataProvider.getPokemonImage(
                    from: frontFemaleURL,
                    onSuccess: {[weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .female)
                    },
                    onError: { },
                    dispatchGroup: group)
            }
            if let frontShinyURL = pokemonDetailed.pokemon.maleShinyUrl {
                dataProvider.getPokemonImage(
                    from: frontShinyURL,
                    onSuccess: {[weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .maleShiny)
                        
                        print("MATTEOLOG: SUCCESS FRONT SHINI")
                    },
                    onError: {
                        print("MATTEOLOG: ERROR FRONT SHINI") },
                    dispatchGroup: group)
            }
            if let frontShinyFemaleURL = pokemonDetailed.pokemon.femaleShinyUrl {
                dataProvider.getPokemonImage(
                    from: frontShinyFemaleURL,
                    onSuccess: {[weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .femaleShiny)
                    },
                    onError: { },
                    dispatchGroup: group)
            }
            if let artwork = pokemonDetailed.pokemon.artwork {
                dataProvider.getPokemonImage(
                    from: artwork,
                    onSuccess: {[weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .artwork)
                    },
                    onError: { },
                    dispatchGroup: group)
            }
            if let sprite = self.pokemonDetailed.pokemon.sprite {
                group.enter()
                dataProvider.getCachedPokemonImage(
                    from: sprite,
                    completion: { [weak self] image in
                        guard let self = self else { return }
                        self.pokemonDetailed.imageSet.setImage(image: image, for: .sprite)
                        
                        group.leave()
                    }, onError: {
                        group.leave()
                    })
            }
            //Get Pokemon Species info
            var chainUrl: String? = nil
            if let speciesURL = pokemonDetailed.pokemon.speciesURL {
                group.enter()
                dataProvider.getSpecieInfo(
                    from: speciesURL,
                    onSuccess: { specie in
                        self.pokemonDetailed.updatePokemon(with: specie)
                        chainUrl = specie.evolution_chain?.url
                        
                        //Get Evolution Chain info
                        if let evolutionChainUrl = chainUrl {
                            
                            dataProvider.getPokemonEvolutionChain(
                                from: evolutionChainUrl,
                                onSuccess: { chain in
                                    self.pokemonDetailed.updatePokemonTree(with: chain)
                                    group.leave()
                                }, onError: {
                                    group.leave()
                                },
                                cacheUsage: .cacheFirst,
                                dispatchGroup: nil)
                        } else {
                            group.leave()
                        }
                        
                    },
                    onError: {
                        group.leave()
                    },
                    cacheUsage: .cacheFirst,
                    dispatchGroup: nil)
            }
            group.notify(
                queue: DispatchQueue.global()) {
                    completion()
                }
        case .full:
            completion()
        }
    }
    
    
}
