//
//  PokedexViewModel.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation

class PokedexViewModel {
    
    private var limit = 20
    
    public var canLoadMorePokemon: Bool {
        
        switch self.currentFilter {
        case.none:
            return pokemonList.count < fullPokemonList.count
        case .type(_):
            return pokemonList.count < fullFilteredList.count
        case .generation(_):
            return pokemonList.count < fullFilteredList.count
        }
    }
    
    private(set) var pokemonList: [Pokemon] {
        didSet{
            guard searchText == nil else { return }
            bindPokemonViewModelToController()
        }
    }
    private var fullPokemonList: [PokemonShort]
    private var fullFilteredList: [PokemonShort]
    
    private(set) var searchList: [PokemonShort] {
        didSet{
            guard let search = searchText else { return }
            
            bindPokemonViewModelSearchToController(searchList.filter({$0.name.starts(with: search)}).map({$0.name}))
        }
    }
    
    private var currentFilter: Filter = .none {
        didSet {
            self.pokemonList = []
            self.fullFilteredList = []
            self.searchPokemon()
        }
    }
    
    private(set) var searchText: String? = nil {
        didSet{
            guard let search = searchText else {
                bindPokemonViewModelToController()
                return
            }
            
            
            
            self.searchList = fullPokemonList.filter({$0.name.lowercased().replacingOccurrences(of: "-", with: " ").starts(with: search.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: " ")))})
        }
    }
    
    var bindPokemonViewModelToController : (() -> ()) = {}
    var bindPokemonViewModelSearchToController: (([String]) -> ()) = {_ in }
    
    init(fullPokemonList: [PokemonShort]) {
        self.pokemonList = []
        self.searchList = []
        self.fullPokemonList = fullPokemonList
        self.fullFilteredList = []
        self.searchPokemon()
    }
    
    public func setSearchText(search: String?) {
        self.searchText = search
    }
    
    private func searchAllPokemon(dataProvider: DataProvider = DataManager.shared) {
        let group = DispatchGroup()
        
        dataProvider.getPokemonList(
            from: self.currentFilter.getUrl(),
            offset: self.pokemonList.count,
            limit: limit,
            onSuccess: { [weak self] list in
                guard let self = self else { return }
                var pokemon = [Pokemon]()
                for res in list.results {
                    let newPokemon = Pokemon(name: res.name, infoUrl: res.url)
                    pokemon.append(newPokemon)
                    dataProvider.getPokemonInfo(
                        from: res.url,
                        onSuccess: { result in
                            newPokemon.updateInfo(with: result)
                        },
                        onError: {
                            newPokemon.setError()
                        },
                        cacheUsage: .cacheFirst,
                        dispatchGroup: group)
                }
                group.notify(queue: DispatchQueue.global()) {
                    self.pokemonList.append(contentsOf: pokemon)
                }
            },
            onError: { },
            cacheUsage: .cacheFirst)
    }
    
    private func searchForGeneration(dataProvider: DataProvider = DataManager.shared) {
        let group = DispatchGroup()
        
        if self.fullFilteredList.isEmpty {
            dataProvider.getPokemonGenerationList(
                from: self.currentFilter.getUrl(),
                offset: self.pokemonList.count,
                limit: limit,
                onSuccess: { [weak self] list in
                    guard let self = self else { return }
                    let newList = list.pokemon_species.map({
                        return PokemonShort(name: $0.name, url: $0.url.replacingOccurrences(of: "pokemon-species", with: "pokemon"))
                    }).sorted(by: {return $0.id < $1.id})
                    self.fullFilteredList = newList
                    
                    var pokemon = [Pokemon]()
                    
                    let startIndex = self.pokemonList.count
                    let endIndex = min(
                        newList.index(startIndex, offsetBy: self.limit),
                        newList.count - 1)
                    
                    for res in newList[startIndex..<endIndex] {
                        let newPokemon = Pokemon(name: res.name, infoUrl: res.url)
                        pokemon.append(newPokemon)
                        
                        dataProvider.getPokemonInfo(
                            from: res.url,
                            onSuccess: { result in
                                newPokemon.updateInfo(with: result)
                                
                            }, onError: {
                                newPokemon.setError()
                            },
                            cacheUsage: .cacheFirst,
                            dispatchGroup: group)
                    }
                    group.notify(queue: DispatchQueue.global()){
                        self.pokemonList.append(contentsOf: pokemon)
                    }
                    
                }, onError: {
                    
                },
                cacheUsage: .cacheFirst)
        } else {
            var pokemon = [Pokemon]()
            
            let startIndex = self.pokemonList.count
            let endIndex = min(fullFilteredList.index(startIndex, offsetBy: self.limit), fullFilteredList.count)
            
            for res in fullFilteredList[startIndex..<endIndex] {
                let newPokemon = Pokemon(name: res.name, infoUrl: res.url)
                pokemon.append(newPokemon)
                dataProvider.getPokemonInfo(
                    from: res.url,
                    onSuccess: { result in
                        newPokemon.updateInfo(with: result)
                    },
                    onError: {
                        newPokemon.setError()
                    },
                    cacheUsage: .cacheFirst,
                    dispatchGroup: group)
            }
            group.notify(queue: DispatchQueue.global()) {
                    self.pokemonList.append(contentsOf: pokemon)
            }
        }
        
    }
    
    private func searchForType(dataProvider: DataProvider = DataManager.shared) {
        let group = DispatchGroup()
        
        if self.fullFilteredList.isEmpty {
            dataProvider.getPokemonTypeList(
                from: self.currentFilter.getUrl(),
                offset: self.pokemonList.count,
                limit: limit,
                onSuccess: { [weak self] list in
                    guard let self = self else { return }
                    self.fullFilteredList = list.pokemon.map({return $0.pokemon})
                    var pokemon = [Pokemon]()
                    
                    let startIndex = self.pokemonList.count
                    let endIndex = min(list.pokemon.index(startIndex, offsetBy: self.limit), list.pokemon.count - 1)
                    
                    for res in list.pokemon[startIndex..<endIndex] {
                        let newPokemon = Pokemon(name: res.pokemon.name, infoUrl: res.pokemon.url)
                        pokemon.append(newPokemon)
                        dataProvider.getPokemonInfo(
                            from: res.pokemon.url,
                            onSuccess: { result in
                                newPokemon.updateInfo(with: result)
                            }, onError: {
                                newPokemon.setError()
                            }, cacheUsage: .cacheFirst,
                            dispatchGroup: group)
                    }
                    group.notify(
                        queue: DispatchQueue.global()) {
                            self.pokemonList.append(contentsOf: pokemon)
                        }
                },
                onError: {
                    
                },
                cacheUsage: .cacheFirst)
        } else {
            var pokemon = [Pokemon]()
            
            let startIndex = self.pokemonList.count
            let endIndex = min(fullFilteredList.index(startIndex, offsetBy: self.limit), fullFilteredList.count)
            
            for res in fullFilteredList[startIndex..<endIndex] {
                let newPokemon = Pokemon(name: res.name, infoUrl: res.url)
                pokemon.append(newPokemon)
                dataProvider.getPokemonInfo(
                    from: res.url,
                    onSuccess: {result in
                        newPokemon.updateInfo(with: result)
                    },
                    onError: {
                        newPokemon.setError()
                    },
                    cacheUsage: .cacheFirst,
                    dispatchGroup: group)
            }
            group.notify(queue: DispatchQueue.global()) {
                    self.pokemonList.append(contentsOf: pokemon)
            }
        }
        
    }
    
    public func searchPokemon() {
        
        switch self.currentFilter {
        case .none:
            searchAllPokemon()
        case .type(_):
            searchForType()
        case .generation(_):
            searchForGeneration()
        }
    }
    
    public func updateFilter(with filter: Filter) {
        self.currentFilter = filter
    }
    
}
