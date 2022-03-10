//
//  TypesHorizontalCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit

class TypesHorizontalCell: UITableViewCell {
    
    var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 26
        return stackView
    }()
    
    var stackViewConstraints: ConstraintGroup!
    

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
        
        self.addSubview(stackView)
        stackViewConstraints = ConstraintGroup(superView: self, subView: stackView, addLeading: false, addTrailing: false)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        stackViewConstraints.leadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor)
        stackViewConstraints.trailingConstraint = self.trailingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor)
        
        stackViewConstraints.leadingConstraint?.isActive = true
        stackViewConstraints.trailingConstraint?.isActive = true
        
    }
    
    public func config(with configuration: TypesHorizontalCellConfiguration) {
        
        
        for type in configuration.types {
            let typeView = TypeView()
            typeView.setup(with: type)
            stackView.addArrangedSubview(typeView)
        }
        
        stackViewConstraints.setConstraints(with: configuration.padding)
    }
    
    override func prepareForReuse() {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

}

struct TypesHorizontalCellConfiguration {
    
    var types: [PokemonType]
    var padding: UIEdgeInsets
    
    
}
