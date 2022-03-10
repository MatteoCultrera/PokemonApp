//
//  PokemonEvolutionCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import UIKit

protocol PokemonEvoutionCellDelegate: AnyObject {
    func didTapOnPokemon(pokemon: PokemonShort)
}

class PokemonEvolutionCell: UITableViewCell {
    
    weak var delegate: PokemonEvoutionCellDelegate?
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    var previousEvolutionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Previous Evolutions"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nextEvolutionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Evolutions"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var card: UIView = {
        
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 10)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 10
        
        card.backgroundColor = Utils.palette.lightGray
        card.layer.cornerRadius = 30
    
        return card
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        let c = ConstraintGroup(superView: self.contentView, subView: card)
        c.setConstraints(with: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
        
        let c2 = ConstraintGroup(superView: card, subView: stackView)
        c2.setConstraints(with: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15))
        
    }
    
    public func config(previousEvoutions: [PokemonShort], nextEvolutions: [PokemonShort]) {
        
        if !previousEvoutions.isEmpty {
            
            stackView.addArrangedSubview(embedLabelInView(label: previousEvolutionsLabel, insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)))
            
            for v in previousEvoutions {
                
                let evolutionView = PokemonEvolutionView()
                evolutionView.config(with: v)
                evolutionView.delegate = self
                stackView.addArrangedSubview(evolutionView)
                
            }
        }
        
        if !nextEvolutions.isEmpty {
            
            stackView.addArrangedSubview(embedLabelInView(label: nextEvolutionsLabel, insets: UIEdgeInsets(top: 22, left: 12, bottom: 0, right: 12)))
            
            for v in nextEvolutions {
                
                let evolutionView = PokemonEvolutionView()
                evolutionView.config(with: v)
                evolutionView.delegate = self
                stackView.addArrangedSubview(evolutionView)
                
            }
        }
        
        
        
    }
    
    override func prepareForReuse() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    private func embedLabelInView(label: UILabel, insets: UIEdgeInsets) -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        view.addSubview(label)
        let c = ConstraintGroup(superView: view, subView: label)
        c.setConstraints(with: insets)
        return view
    }

}

extension PokemonEvolutionCell: PokemonEvolutionViewDelegate {
    func delegateDidTapOnPokemon(pokemon: PokemonShort) {
        delegate?.didTapOnPokemon(pokemon: pokemon)
    }
}
