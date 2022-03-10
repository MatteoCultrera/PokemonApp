//
//  TypesTackView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 05/03/22.
//

import UIKit

class TypesStackView: UIStackView {
    
    var typeViews: [TypeView] = {
        
        var toRet = [TypeView]()
        
        for i in 0..<2 {
            toRet.append(TypeView())
        }
        
        return toRet
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupForShimmer() {
        for view in typeViews {
            view.setupForShimmer()
            view.layoutSubviews()
        }
    }
    
    public func setup(with types: [PokemonType]) {
     
        for i in 0..<2{
            if types.count > i {
                self.typeViews[i].isHidden = false
                self.typeViews[i].setup(with: types[i])
            } else {
                self.typeViews[i].isHidden = true
            }
        }
        
        
    }
    
    private func setupUI() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.backgroundColor = .clear
        self.spacing = 7
        
        for view in typeViews {
            self.addArrangedSubview(view)
        }
        
        
    }

}
