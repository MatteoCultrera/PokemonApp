//
//  StatsCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit

class StatsCell: UITableViewCell {
    
    var scheme: StatsScheme = {
        return StatsScheme()
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
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = UIColor.white
        title.textAlignment = .left
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        title.setContentHuggingPriority(.required, for: .vertical)
        title.text = "Base Stats"
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

        let c3 = ConstraintGroup(superView: card, subView: innerCard, addTop: false)
        c3.setConstraints(with: UIEdgeInsets(top: 0, left: 15, bottom: 23, right: 15))
        titleLabel.bottomAnchor.constraint(equalTo: innerCard.topAnchor, constant: -16).isActive = true
        let c4 = ConstraintGroup(superView: innerCard, subView: scheme)
        c4.setConstraints(with: UIEdgeInsets(top: 23, left: 13, bottom: 23, right: 13))
//
    }
    
    public func config(with stats: [Stat]) {
        scheme.config(with: StatsSchemeConfiguration(stats: stats))
    }

}
