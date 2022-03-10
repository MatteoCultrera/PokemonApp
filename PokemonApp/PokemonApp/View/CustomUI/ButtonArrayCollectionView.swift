//
//  ButtonArrayCollectionView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import UIKit

class ButtonArrayCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
    
    convenience init(with configuration: ButtonArrayCollectionViewConfiguration) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = configuration.insets
        layout.itemSize = configuration.buttonSize
        layout.minimumLineSpacing = configuration.verticalSpacing
        layout.minimumInteritemSpacing = configuration.elementsSpacing
        
        self.init(frame: .zero, collectionViewLayout: layout)
        self.setupUI()
    }

    private func setupUI() {
        self.backgroundColor = .clear
    }
    
}

struct ButtonArrayCollectionViewConfiguration {
    
    var insets: UIEdgeInsets
    var buttonSize: CGSize
    var verticalSpacing: CGFloat
    var elementsSpacing: CGFloat
    
    
    init(padding: UIEdgeInsets, buttonSize: CGSize, verticalSpacing: CGFloat, elementsSpacing: CGFloat) {
        self.insets = padding
        self.buttonSize = buttonSize
        self.verticalSpacing = verticalSpacing
        self.elementsSpacing = elementsSpacing
    }
    
    init() {
        self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.buttonSize = CGSize(width: 50, height: 50)
        self.verticalSpacing = 30
        self.elementsSpacing = 20
    }
    
}
