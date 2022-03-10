//
//  CollectionViewButtonCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import UIKit

protocol CollectionViewButtonCellDelegate: AnyObject {
    func collectionButtonTapped(with index: Int)
}

class CollectionViewButtonCell: UICollectionViewCell {
    
    private var index = 0
    
    weak var delegate: CollectionViewButtonCellDelegate?
    
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addFadeAnimationPressActions()
        return button
    }()
    
    @objc func buttonTapped() {
        delegate?.collectionButtonTapped(with: index)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    public func config(index: Int, with image: UIImage?) {
        self.index = index
        button.setImage(image, for: .normal)
    }
    
}
