//
//  PokemonDataSource.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation
import UIKit

protocol PokemonDataSourceDelegate: AnyObject {
    func pokemonTapped(pokemon: PokemonShort)
}

class PokemonDataSource: NSObject, UITableViewDataSource {
    
    weak var delegate: PokemonDataSourceDelegate?
    
    private enum Cells {
        case transparentHeaderCell
        case nameCell(text: String)
        case typesCell(TypesHorizontalCellConfiguration)
        case flavourTextCell(FlavourTextCellConfiguration)
        case statCell([Stat])
        case transparentBottomCell
        case typesRelation(TypesRelationCellConfiguration)
        case evolutionCell(previousEvolutions: [PokemonShort], nextEvolutions: [PokemonShort])
    }
    
    private var items: [Cells]
    private var paddingTopCell: CGFloat? = nil
    
    init(pokemon: PokemonDetailed, paddingTopCell: CGFloat? = nil, tableView: UITableView) {
        
        self.items = [Cells]()
        
        if paddingTopCell != nil {
            self.items.append(.transparentHeaderCell)
        }
        self.items.append(.nameCell(text: pokemon.name.replacingOccurrences(of: "-", with: " ").capitalized))
        self.items.append(.typesCell(
            TypesHorizontalCellConfiguration(
                types: pokemon.pokemon.types.map({ return $0.pokemonType }),
                padding: UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20))))
        
        if let pokedexEntry = pokemon.pokedexDescription {
            self.items.append(.flavourTextCell(FlavourTextCellConfiguration(
                title: "Pokedex Entry",
                text: pokedexEntry)))
        }
        
        let previousEvolutions = pokemon.getPreviousEvolutions()
        let nextEvolutions = pokemon.getNextEvolutions()
        
        if !previousEvolutions.isEmpty || !nextEvolutions.isEmpty {
            self.items.append(.evolutionCell(previousEvolutions: previousEvolutions, nextEvolutions: nextEvolutions))
        }
        
        
        self.items.append(.statCell(pokemon.pokemon.stats))
        
        var doubleDamageTo = [PokemonType]()
        var doubleDamageFrom = [PokemonType]()
        var halfDamageTo = [PokemonType]()
        var halfDamageFrom = [PokemonType]()
        var noDamageFrom = [PokemonType]()
        var noDamageTo = [PokemonType]()
        
        for type in pokemon.pokemon.types {
            let relations = TypesRelationManager.singleton.getTypeRelations(for: type.pokemonType)
            
            doubleDamageTo.append(contentsOf: relations?.doubleDamageTo ?? [])
            doubleDamageFrom.append(contentsOf: relations?.doubleDamageFrom ?? [])
            halfDamageTo.append(contentsOf: relations?.halfDamageTo ?? [])
            halfDamageFrom.append(contentsOf: relations?.halfDamageFrom ?? [])
            noDamageTo.append(contentsOf: relations?.noDamageTo ?? [])
            noDamageFrom.append(contentsOf: relations?.noDamageFrom ?? [])
        }
        
        var strengths = [(String, [PokemonType])]()
        
        if !doubleDamageTo.isEmpty { strengths.append(("Double damage to", doubleDamageTo))}
        if !halfDamageFrom.isEmpty { strengths.append(("Half damage from", halfDamageFrom))}
        if !noDamageFrom.isEmpty { strengths.append(("No damage from", noDamageFrom))}
        
        if !strengths.isEmpty {
            self.items.append(.typesRelation(TypesRelationCellConfiguration(title: "Strengths", types: strengths)))
        }
        
        var weaknesses = [(String, [PokemonType])]()
        if !doubleDamageFrom.isEmpty { weaknesses.append(("Double damage from", doubleDamageFrom))}
        if !halfDamageTo.isEmpty { weaknesses.append(("Half damage to", halfDamageTo))}
        if !noDamageTo.isEmpty { weaknesses.append(("No damage to", noDamageTo))}
        
        if !weaknesses.isEmpty {
            self.items.append(.typesRelation(TypesRelationCellConfiguration(title: "Weaknesses", types: weaknesses)))
        }
        
        self.items.append(.transparentBottomCell)
        
        self.paddingTopCell = paddingTopCell
        
        tableView.register(LabelCell.self, forCellReuseIdentifier: "LabelCell")
        tableView.register(TypesHorizontalCell.self, forCellReuseIdentifier: "TypesHorizontalCell")
        tableView.register(FlavourTextCell.self, forCellReuseIdentifier: "FlavourTextCell")
        tableView.register(StatsCell.self, forCellReuseIdentifier: "StatsCell")
        tableView.register(TypesRelationCell.self, forCellReuseIdentifier: "TypesRelationCell")
        tableView.register(PokemonEvolutionCell.self, forCellReuseIdentifier: "PokemonEvolutionCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .transparentHeaderCell:
            let cell = UITableViewCell()
            cell.autoresizingMask = [.flexibleWidth]
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: self.paddingTopCell ?? 0).isActive = true
            cell.contentView.isUserInteractionEnabled = false
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .clear
            return cell
        case .nameCell(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") ?? LabelCell(style: .default, reuseIdentifier: "LabelCell")
            if let label = cell as? LabelCell {
                label.config(
                    with: LabelCellConfiguration(
                        title: NSAttributedString(string: text, attributes: [ .font : UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor : UIColor.white ]),
                        insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                        alignment: .center, numLines: 0))
            }
            return cell
        case .transparentBottomCell:
            let cell = UITableViewCell()
            cell.autoresizingMask = [.flexibleWidth]
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
            cell.contentView.isUserInteractionEnabled = false
            cell.backgroundColor = .clear
            return cell
        case .typesCell(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypesHorizontalCell") ?? TypesHorizontalCell(style: .default, reuseIdentifier: "TypesHorizontalCell")
            if let types = cell as? TypesHorizontalCell {
                types.config(with: configuration)
            }
            return cell
        case .flavourTextCell(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlavourTextCell") ?? FlavourTextCell(style: .default, reuseIdentifier: "FlavourTextCell")
            if let cell = cell as? FlavourTextCell {
                cell.configure(with: configuration)
            }
            return cell
        case .statCell(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell") ?? StatsCell(style: .default, reuseIdentifier: "StatsCell")
            if let cell = cell as? StatsCell {
                cell.config(with: configuration)
            }
            return cell
        case .typesRelation(let configuration):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypesRelationCell") ?? TypesRelationCell(style: .default, reuseIdentifier: "TypesRelationCell")
            if let cell = cell as? TypesRelationCell {
                
                cell.frame = tableView.bounds
                cell.layoutIfNeeded()
                
                cell.config(with: configuration)
                
            }
            
            return cell
        case .evolutionCell(previousEvolutions: let previousEvolutions, nextEvolutions: let nextEvolutions):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonEvolutionCell") ?? PokemonEvolutionCell(style: .default, reuseIdentifier: "PokemonEvolutionCell")
            if let cell = cell as? PokemonEvolutionCell {
                cell.config(previousEvoutions: previousEvolutions, nextEvolutions: nextEvolutions)
                cell.delegate = self
            }
            return cell
        }
        
    }
}

extension PokemonDataSource: PokemonEvoutionCellDelegate {
    func didTapOnPokemon(pokemon: PokemonShort) {
        delegate?.pokemonTapped(pokemon: pokemon)
    }
}
