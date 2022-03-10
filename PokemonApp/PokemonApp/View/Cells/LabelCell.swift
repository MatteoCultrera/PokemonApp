//
//  LabelCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import UIKit

class LabelCell: UITableViewCell {
    
    var label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    
    private func setupUI() {
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.addSubview(label)
        
        
        
        leadingConstraint = label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        trailingConstraint = self.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        topConstraint = label.topAnchor.constraint(equalTo: self.topAnchor)
        bottomConstraint = self.bottomAnchor.constraint(equalTo: label.bottomAnchor)
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = true
        topConstraint?.isActive = true
        bottomConstraint?.isActive = true
    }
    
    public func config(with configuration: LabelCellConfiguration) {
        leadingConstraint?.constant = configuration.insets.left
        trailingConstraint?.constant = configuration.insets.right
        topConstraint?.constant = configuration.insets.top
        bottomConstraint?.constant = configuration.insets.bottom
        
        self.label.attributedText = configuration.title
        self.label.textAlignment = configuration.alignment
        self.label.numberOfLines = configuration.numLines
    }
    

}


struct LabelCellConfiguration {
    
    let title: NSAttributedString
    let insets: UIEdgeInsets
    let alignment: NSTextAlignment
    let numLines: Int
    
    
}
