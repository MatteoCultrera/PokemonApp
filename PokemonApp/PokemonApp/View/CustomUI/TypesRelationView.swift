//
//  TypesRelationView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation
import UIKit

class TypesRelationView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionViewHeight: NSLayoutConstraint?
    
    var dataSource: [PokemonType]!
    
    var collectionView: ButtonArrayCollectionView = {
        
        let buttonArray = ButtonArrayCollectionView(with: ButtonArrayCollectionViewConfiguration(
            padding: UIEdgeInsets.zero, buttonSize: CGSize(width: 30, height: 30),
            verticalSpacing: 10, elementsSpacing: 10))
        
        return buttonArray
        
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        self.addSubview(label)
        var c = ConstraintGroup(superView: self, subView: label, addBottom: false, addTrailing: false)
        
        c.bottomConstraint = self.bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor)
        c.setConstraints(with: UIEdgeInsets(top: 20, left: 13, bottom: -20, right: 0))
        c.bottomConstraint?.isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        
        self.addSubview(collectionView)
        var c2 = ConstraintGroup(superView: self, subView: collectionView, addBottom: false, addLeading: false)
        c2.bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        c2.bottomConstraint?.priority = .defaultHigh
        c2.setConstraints(with: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 13))
        c2.bottomConstraint?.isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20).isActive = true
        
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 30)
        
        collectionView.backgroundColor = .clear
        
        collectionViewHeight?.isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CollectionViewButtonCell.self, forCellWithReuseIdentifier: "CollectionViewButtonCell")
        
    }
    
    public func config(text: String, types: [PokemonType]) {
        
        label.text = text
        dataSource = types

        self.layoutIfNeeded()
        collectionView.reloadData()
        collectionViewHeight?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewButtonCell", for: indexPath)
        if let button = cell as? CollectionViewButtonCell {
            let item = dataSource[indexPath.item].getImage()
            button.config(index: indexPath.item, with: item)
            button.isUserInteractionEnabled = false
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

