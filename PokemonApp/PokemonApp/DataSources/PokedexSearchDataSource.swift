//
//  PokedexSearchDataSource.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

protocol PokedexSearchDelegate: AnyObject {
    func userDidTapOnPokemon(name: String, url: String)
}

class PokedexSearchDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: PokedexSearchDelegate?
    
    enum Cells {
        case pokemonSearchCell(PokemonShort)
        case notFound
    }
    
    private let idCell: String = "SearchCell"
    private var items: [Cells] = [Cells]()
    private var paddingTopCell: CGFloat? = nil
    
    init(items: [PokemonShort], paddingTopCell: CGFloat? = nil, tableView: UITableView) {
        
        self.items = items.map({return Cells.pokemonSearchCell($0)})
        
        if self.items.isEmpty {
            self.items.append(.notFound)
        }
        
        self.paddingTopCell = paddingTopCell
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: idCell)
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
            cell.heightAnchor.constraint(equalToConstant: Utils.shared.getWindowSize().height).isActive = true
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        } else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? SearchCell(style: .default, reuseIdentifier: idCell)
            
            
            
            if let cell = cell as? SearchCell{
                switch items[indexPath.row] {
                case .pokemonSearchCell(let pokemon):
                    cell.config(with: pokemon, indexPath: indexPath)
                    cell.delegate = self
                case .notFound:
                    cell.configNotFound()
                }
            }
            return cell
        }
    }
    
}

extension PokedexSearchDataSource: SearchCellDelegate {
    func pokemonTapped(with indexPath: IndexPath) {
        
        if case .pokemonSearchCell(let pokemon) = items[indexPath.row] {
            delegate?.userDidTapOnPokemon(name: pokemon.name, url: pokemon.url)
        }
        
    }
    
    
}
