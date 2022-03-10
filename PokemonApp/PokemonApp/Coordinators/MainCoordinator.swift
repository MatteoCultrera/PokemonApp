//
//  MainCoordinator.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

class MainCoordinator {
    
    init(){
    }
    
    func start(from window: UIWindow?) {
        let dispatchGroup = DispatchGroup()
        
        let viewController = LoadingVC()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        Utils.shared.windowSize = window?.bounds.size
        
        var pokemon = [PokemonShort]()
        
        //Get all pokemon to search them
        dispatchGroup.enter()
        DataManager.shared.getAllPokemon(
            from: Filter.none.getUrl(),
            onSuccess: { res in
                pokemon = res.results
                dispatchGroup.leave()
            }, onError: {
                dispatchGroup.leave()
            },
            cacheUsage: .networkFirst)
        
        //Fill in the types relations
        for type in PokemonType.allCases {
            
            let url = "https://pokeapi.co/api/v2/type/\(type.getId())/"
            
            dispatchGroup.enter()
            DataManager.shared.getTypeInfo(
                from: url,
                onSuccess: { api in
                    TypesRelationManager.singleton.setTypeRelations(for: type, with: api)
                    
                    dispatchGroup.leave()
                }, onError: {
                    dispatchGroup.leave()
                }, cacheUsage: .networkFirst)
        }
        
        
        
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            self.goToPokedex(from: viewController, with: pokemon)
        }
    }
    
    
    func goToPokedex(from viewController: UIViewController, with pokemon: [PokemonShort]) {
        
        DispatchQueue.main.async {
            let pokedexVC = PokedexVC()
            let pokedexViewModel = PokedexViewModel(fullPokemonList: pokemon)
            pokedexVC.pokedexViewModel = pokedexViewModel
            pokedexVC.coordinator = self
            pokedexVC.modalPresentationStyle = .fullScreen
            viewController.present(pokedexVC, animated: true)
        }
        
    }
    
    func presentPokemonDetail(from viewController: UIViewController, with pokemon: Pokemon) {
        
        LoaderManager.showLoader(from: viewController)
        let pokemonVM = PokemonViewModel(pokemon: pokemon)
        pokemonVM.completePokemonInfo {
            DispatchQueue.main.async {
                let vc = PokemonDetailsVC()
                vc.pokemonViewModel = pokemonVM
                vc.coordinator = self
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                LoaderManager.hideLoader(from: viewController)
                viewController.present(nav, animated: true, completion: nil)
            }
        } onError: {
            DispatchQueue.main.async {
                LoaderManager.hideLoader(from: viewController)
                let errorVC = PokemonNotFoundVC()
                errorVC.modalPresentationStyle = .pageSheet
                errorVC.config(with: pokemon.name.replacingOccurrences(of: "-", with: " ").capitalized)
                viewController.present(errorVC, animated: true, completion: nil)
            }
        }
    }
    
    func presentPokemonDetail(from viewController: UIViewController, with name: String, url: String) {
        LoaderManager.showLoader(from: viewController)
        let pokemonVM = PokemonViewModel(name: name, url: url)
        pokemonVM.completePokemonInfo {
            DispatchQueue.main.async {
                let vc = PokemonDetailsVC()
                vc.pokemonViewModel = pokemonVM
                vc.coordinator = self
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                LoaderManager.hideLoader(from: viewController)
                viewController.present(nav, animated: true, completion: nil)
            }
        } onError: {
            DispatchQueue.main.async {
                LoaderManager.hideLoader(from: viewController)
                let errorVC = PokemonNotFoundVC()
                errorVC.modalPresentationStyle = .pageSheet
                errorVC.config(with: name.replacingOccurrences(of: "-", with: " ").capitalized)
                viewController.present(errorVC, animated: true, completion: nil)
            }
        }
    }
    
    func pushPokemonDetailed(from navigationController: UINavigationController, with name: String, url: String) {
        
        guard let top = navigationController.topViewController else {
            return
        }
        
        LoaderManager.showLoader(from: top)
        let pokemonVM = PokemonViewModel(name: name, url: url)
        pokemonVM.completePokemonInfo {
            DispatchQueue.main.async {
                let vc = PokemonDetailsVC()
                vc.pokemonViewModel = pokemonVM
                vc.coordinator = self
                LoaderManager.hideLoader(from: top)
                navigationController.pushViewController(vc, animated: true)
            }
        } onError: {
            DispatchQueue.main.async {
                LoaderManager.hideLoader(from: top)
                let errorVC = PokemonNotFoundVC()
                errorVC.config(with: name.replacingOccurrences(of: "-", with: " ").capitalized)
                errorVC.modalPresentationStyle = .pageSheet
                navigationController.present(errorVC, animated: true)
            }
        }
    }
    
    
    
}
