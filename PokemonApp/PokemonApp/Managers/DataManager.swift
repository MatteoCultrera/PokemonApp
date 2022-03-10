//
//  DataManager.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation
import UIKit

protocol DataProvider: AnyObject {
    
    func getAllPokemon(from url: String, onSuccess: @escaping (GetPokemonListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage)
    
    func getTypeInfo(from url: String, onSuccess: @escaping (TypeAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage)
    
    func getPokemonList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage)
    
    func getPokemonInfo(from url: String, onSuccess: @escaping (PokemonApiPokemon) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage, dispatchGroup: DispatchGroup?)
    
    func getPokemonGenerationList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonGenerationListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage)
    
    func getPokemonTypeList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonTypeListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage)
    
    func getSpecieInfo(from url: String, onSuccess: @escaping (GetPokemonSpecieAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage, dispatchGroup: DispatchGroup?)
    
    func getPokemonEvolutionChain(from url: String, onSuccess: @escaping (EvolutionChainAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage, dispatchGroup: DispatchGroup?)
    
    func getCachedPokemonImage(from urlString: String, completion: @escaping(UIImage) -> (), onError: @escaping () -> ())
    
    func getPokemonImage(from urlString: String, onSuccess: @escaping(UIImage?) -> (), onError:  @escaping () -> (), dispatchGroup: DispatchGroup?)
}

class DataManager: DataProvider {
    
    static var shared: DataManager = DataManager()
    
    
    private var pokemonListCache = Cache<String, GetPokemonListAPI>()
    private var typeCacheManager = Cache<String, TypeAPI>()
    private var pokemonCache = Cache<String, PokemonApiPokemon>()
    private var pokemonGenerationCache = Cache<String, GetPokemonGenerationListAPI>()
    private var pokemonTypeCache = Cache<String, GetPokemonTypeListAPI>()
    private var imageCache = Cache<String, Data>()
    private var speciesCache = Cache<String, GetPokemonSpecieAPI>()
    private var evolutionChainCache = Cache<String, EvolutionChainAPI>()
    
    public func getAllPokemon(from url: String, onSuccess: @escaping (GetPokemonListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none){
        
        var pokemonCompleteUrl = url
        pokemonCompleteUrl.append("?limit=1500")
        
        
        if cacheUsage == .cacheFirst, let value = self.pokemonListCache.value(forKey: pokemonCompleteUrl) {
            onSuccess(value)
            return
        }
        
        let networkManager = NetworkManager<GetPokemonListAPI>()
        
        networkManager.getPokemonNames(from: pokemonCompleteUrl, onSuccess: { [weak self]
            res in
            guard let self = self else { return }
            if cacheUsage != .none {
                self.pokemonListCache.insert(res, forKey: pokemonCompleteUrl)
            }
            onSuccess(res)
        }, onError: { [weak self] in
            guard let self = self else { return }
            if cacheUsage != .none, let res = self.pokemonListCache.value(forKey: pokemonCompleteUrl) {
                onSuccess(res)
            } else {
                onError()
            }
        })
    }
    
    public func getTypeInfo(from url: String, onSuccess: @escaping (TypeAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none) {
        
        if cacheUsage == .cacheFirst, let value = typeCacheManager.value(forKey: url) {
            onSuccess(value)
            return
        }
        
        let manager = NetworkManager<TypeAPI>()
        
        manager.getAPIDetails(from: url, onSuccess: { [weak self] typeApi in
            guard let self = self else { return }
            if cacheUsage != .none {
                self.typeCacheManager.insert(typeApi, forKey: url)
            }
            onSuccess(typeApi)
            
        }, onError: { [weak self] in
            guard let self = self else { return }
            if cacheUsage != .none, let value = self.typeCacheManager.value(forKey: url) {
                onSuccess(value)
            } else {
                onError()
            }
        })
    }
    
    public func getPokemonList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none) {
        
        var pokemonCompleteUrl = url
        
        if offset > 0 {
            pokemonCompleteUrl.append("?offset=\(offset)?limit=\(limit)")
        } else if limit > 0 {
            pokemonCompleteUrl.append("?limit=\(limit)")
        }
        
        if cacheUsage == .cacheFirst, let value = pokemonListCache.value(forKey: pokemonCompleteUrl) {
            onSuccess(value)
            return
        }
        
        let networkManager = NetworkManager<GetPokemonListAPI>()
        networkManager.getPokemonNames(
            from: pokemonCompleteUrl,
            onSuccess: { [weak self] api in
                guard let self = self else { return }
                
                if cacheUsage != .none {
                    self.pokemonListCache.insert(api, forKey: pokemonCompleteUrl)
                }
                onSuccess(api)
            },
            onError: { [weak self] in
                guard let self = self else { return }
                if cacheUsage != .none, let value = self.pokemonListCache.value(forKey: pokemonCompleteUrl) {
                    onSuccess(value)
                } else {
                    onError()
                }
            })
    }
    
    func getPokemonGenerationList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonGenerationListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none){
        
        var pokemonCompleteUrl = url
        
        if offset > 0 {
            pokemonCompleteUrl.append("?offset=\(offset)?limit=\(limit)")
        } else if limit > 0 {
            pokemonCompleteUrl.append("?limit=\(limit)")
        }
        
        if cacheUsage == .cacheFirst, let value = pokemonGenerationCache.value(forKey: pokemonCompleteUrl) {
            onSuccess(value)
            return
        }
        
        let networkManager = NetworkManager<GetPokemonGenerationListAPI>()
        
        networkManager.getPokemonNames(
            from: pokemonCompleteUrl,
            onSuccess: { [weak self] list in
                guard let self = self else { return }
                
                if cacheUsage != .none {
                    self.pokemonGenerationCache.insert(list, forKey: pokemonCompleteUrl)
                }
                onSuccess(list)
            },
            onError: { [weak self] in
                guard let self = self else { return }
                if cacheUsage != .none, let value = self.pokemonGenerationCache.value(forKey: pokemonCompleteUrl) {
                    onSuccess(value)
                } else {
                    onError()
                }
            })
    }
    
    func getPokemonTypeList(from url: String, offset: Int, limit: Int, onSuccess: @escaping (GetPokemonTypeListAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none) {
        
        var pokemonCompleteUrl = url
        if offset > 0 {
            pokemonCompleteUrl.append("?offset=\(offset)?limit=\(limit)")
        } else if limit > 0 {
            pokemonCompleteUrl.append("?limit=\(limit)")
        }
        
        if cacheUsage == .cacheFirst, let value = pokemonTypeCache.value(forKey: pokemonCompleteUrl) {
            onSuccess(value)
        }
        
        let networkManager = NetworkManager<GetPokemonTypeListAPI>()
        
        networkManager.getPokemonNames(
            from: pokemonCompleteUrl,
            onSuccess: {[weak self] res in
                guard let self = self else { return }
                if cacheUsage != .none {
                    self.pokemonTypeCache.insert(res, forKey: pokemonCompleteUrl)
                }
                onSuccess(res)
            }, onError: { [weak self] in
                guard let self = self else { return }
                if cacheUsage != .none, let value = self.pokemonTypeCache.value(forKey: pokemonCompleteUrl) {
                    onSuccess(value)
                } else {
                    onError()
                }
            })
        
    }
    
    func getPokemonEvolutionChain(from url: String, onSuccess: @escaping (EvolutionChainAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage, dispatchGroup: DispatchGroup?) {
        
        if cacheUsage == .cacheFirst, let value = evolutionChainCache.value(forKey: url) {
            onSuccess(value)
            return
        }
        
        let networkManager = NetworkManager<EvolutionChainAPI>()
        
        dispatchGroup?.enter()
        networkManager.getAPIDetails(
            from: url,
            onSuccess: { [weak self] api in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if cacheUsage != .none {
                        self.evolutionChainCache.insert(api, forKey: url)
                    }
                    onSuccess(api)
                }
            },
            onError: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    if cacheUsage != .none, let value = self.evolutionChainCache.value(forKey: url) {
                        onSuccess(value)
                    } else{
                        onError()
                    }
                }
                
            })
        
        
        
    }
    
    func getSpecieInfo(from url: String, onSuccess: @escaping (GetPokemonSpecieAPI) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage, dispatchGroup: DispatchGroup? = nil) {
        
        if cacheUsage == .cacheFirst, let value = speciesCache.value(forKey: url) {
            onSuccess(value)
            return
        }
        
        dispatchGroup?.enter()
        let networkManager = NetworkManager<GetPokemonSpecieAPI>()
        
        networkManager.getAPIDetails(
            from: url,
            onSuccess: { [weak self] api in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    if cacheUsage != .none {
                        self.speciesCache.insert(api, forKey: url)
                    }
                    onSuccess(api)
                }
            },
            onError: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    if cacheUsage != .none, let value = self.speciesCache.value(forKey: url) {
                        onSuccess(value)
                    } else {
                        onError()
                    }
                }
            })
        
    }
    
    func getPokemonInfo(from url: String, onSuccess: @escaping (PokemonApiPokemon) -> (), onError: @escaping () -> (), cacheUsage: CacheUsage = .none, dispatchGroup: DispatchGroup? = nil) {
        
        if cacheUsage == .cacheFirst, let value = pokemonCache.value(forKey: url) {
            onSuccess(value)
            return
        }
        
        let networkManager = NetworkManager<PokemonApiPokemon>()
        
        dispatchGroup?.enter()
        networkManager.getAPIDetails(
            from: url,
            onSuccess: { [weak self] result in
                guard let self = self else { return }
                if cacheUsage != .none {
                    self.pokemonCache.insert(result, forKey: url)
                }
                DispatchQueue.main.async {
                    
                    dispatchGroup?.leave()
                    onSuccess(result)
                }
            },
            onError: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    if cacheUsage != .none, let value = self.pokemonCache.value(forKey: url) {
                        onSuccess(value)
                    } else {
                        onError()
                    }
                }
            })
        
    }
    
    
    
    public func getCachedPokemonImage(from urlString: String, completion: @escaping(UIImage) -> (), onError: @escaping () -> ()) {
        
        if let value = imageCache.value(forKey: urlString), let image = UIImage(data: value) {
            completion(image)
            return
        }
        
        let networkManager = NetworkManager<PokemonApiPokemon>()
        
        networkManager.getPokemonImage(
            from: urlString,
            onSuccess: { [weak self] data in
                guard let self = self else { return }
                if let image = UIImage(data: data) {
                    self.imageCache.insert(data, forKey: urlString)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError()
                    }
                }
                
            },
            onError: { [weak self] in
                guard let self = self else { return }
                if let value = self.imageCache.value(forKey: urlString), let image = UIImage(data: value) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        onError()
                    }
                }
            })
        
    }
    
    public func getPokemonImage(from urlString: String, onSuccess: @escaping(UIImage?) -> (), onError: @escaping () -> (), dispatchGroup: DispatchGroup? = nil) {
        
        let networkManager = NetworkManager<PokemonApiPokemon>()
        
        dispatchGroup?.enter()
        networkManager.getPokemonImage(
            from: urlString,
            onSuccess: { data in
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    onSuccess(UIImage(data: data))
                }
            },
            onError: {
                DispatchQueue.main.async {
                    dispatchGroup?.leave()
                    onError()
                }
            })
        
    }
    
    
}

public enum CacheUsage {
    case none
    case networkFirst
    case cacheFirst
}
