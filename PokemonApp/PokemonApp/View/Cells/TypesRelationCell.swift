//
//  TypesRelationCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation
import UIKit

class TypesRelationCell: UITableViewCell {
    
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
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = UIColor.white
        title.textAlignment = .left
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.setContentHuggingPriority(.required, for: .vertical)
        return title
    }()
    
    var innerCard: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.palette.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 4
        
        view.layer.cornerRadius = 20
        return view
    }()
    
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
        let c2 = ConstraintGroup(superView: card, subView: titleLabel, addBottom: false)
        c2.setConstraints(with: UIEdgeInsets(top: 18, left: 27, bottom: 0, right: 27))
        
        let _ = ConstraintGroup(superView: innerCard, subView: stackView)
        
        card.addSubview(innerCard)
        
        NSLayoutConstraint.activate([
            innerCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            innerCard.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            card.trailingAnchor.constraint(equalTo: innerCard.trailingAnchor, constant: 15),
            card.bottomAnchor.constraint(equalTo: innerCard.bottomAnchor, constant: 23)
        ])
        
        
        
    }
    
    override func prepareForReuse() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    public func config(with configuration: TypesRelationCellConfiguration) {
        
        titleLabel.text = configuration.title
        
        for element in configuration.types {
            let typeView = TypesRelationView()
            stackView.addArrangedSubview(typeView)
            typeView.config(text: element.text, types: element.types)
        }
        
    }
}

struct TypesRelationCellConfiguration {
    
    let title: String
    let types: [(text: String, types: [PokemonType])]
    
}
