//
//  PokedexPokemonDataSource.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

protocol PokedexPokemonDataSourceDelegate: AnyObject {
    func loadMorePokemon()
    func goToPokemon(with pokemon: Pokemon)
}

class PokedexPokemonDataSource: NSObject, UITableViewDataSource {
    
    private var loadingCells: Bool = false
    weak var delegate: PokedexPokemonDataSourceDelegate?
    
    private enum Cells {
        case loadingCell
        case pokemonCell(pokemon: Pokemon)
        case bottomLoadCell
    }
    
    private enum CellsReuseIdentifier: String {
        case pokemonCell = "PokemonCell"
        case bottomLoadCell = "BottomLoadCell"
    }
    
    
    private var items: [Cells]
    private var paddingTopCell: CGFloat? = nil
    
    init(items: [Pokemon], canLoadMorePokemon: Bool, paddingTopCell: CGFloat? = nil, tableView: UITableView) {
        
        self.items = [Cells]()

        if items.isEmpty {
            for _ in 0..<6 {
                self.items.append(.loadingCell)
            }
        }
        
        for value in items {
            self.items.append(Cells.pokemonCell(pokemon: value))
        }
        
        if canLoadMorePokemon {
            self.items.append(.bottomLoadCell)
        }
        
        self.paddingTopCell = paddingTopCell
        
        tableView.register(PokedexPokemonCell.self, forCellReuseIdentifier: CellsReuseIdentifier.pokemonCell.rawValue)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if paddingTopCell != nil {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paddingTopCell != nil {
            if section == 0 {
                return 1
            }
            return items.count + 1
        } else {
            return items.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let padding = paddingTopCell{
            let cell = UITableViewCell()
            cell.heightAnchor.constraint(equalToConstant: padding).isActive = true
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.row == items.count {
            let cell = UITableViewCell()
            cell.heightAnchor.constraint(equalToConstant: 40).isActive = true
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        } else {
            switch items[indexPath.row] {
            case .loadingCell:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CellsReuseIdentifier.pokemonCell.rawValue) ?? PokedexPokemonCell(style: .default, reuseIdentifier: CellsReuseIdentifier.pokemonCell.rawValue)
                
                if let cell = cell as? PokedexPokemonCell {
                    cell.configShimmer()
                }
                
                return cell
            case .pokemonCell(let pokemon):
                switch pokemon.state {
                case .shimmer, .error:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellsReuseIdentifier.pokemonCell.rawValue) ?? PokedexPokemonCell(style: .default, reuseIdentifier: CellsReuseIdentifier.pokemonCell.rawValue)
                    
                    if let cell = cell as? PokedexPokemonCell {
                        cell.configShimmer()
                    }
                    
                    return cell
                case .configured:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellsReuseIdentifier.pokemonCell.rawValue) ?? PokedexPokemonCell(style: .default, reuseIdentifier: CellsReuseIdentifier.pokemonCell.rawValue)
                    
                    if let cell = cell as? PokedexPokemonCell {
                        cell.config(with: PokedexPokemonCellConfiguration(
                            pokemonTypes: pokemon.types.map({return $0.pokemonType}),
                            pokemonName: pokemon.name,
                            pokemonImageUrl: pokemon.imageURL))
                        cell.delegate = self
                        cell.indexPath = indexPath
                    }
                    return cell
                }
            case .bottomLoadCell:
                let cell = LoadingCell()
                cell.config()
                if !loadingCells {
                    loadingCells = true
                    delegate?.loadMorePokemon()
                }
                return cell
            }
        }
    }
    
}

extension PokedexPokemonDataSource: PokedexPokemonCellDelegate {
    
    func didTapOnCard(at index: IndexPath?) {
        if let row = index?.row,
           case .pokemonCell(let pokemon) = items[row] {
            delegate?.goToPokemon(with: pokemon)
        }
    }    
}
