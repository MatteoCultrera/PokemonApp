//
//  ProgressView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit

class ProgressView: UIView {

    
    var progressConstraint: NSLayoutConstraint?
    var progress: CGFloat = 0
    
    var outerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var innerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        let _ = ConstraintGroup(superView: self, subView: outerView)
        let _ = ConstraintGroup(superView: outerView, subView: innerView, addTrailing: false)
        
        progressConstraint = innerView.widthAnchor.constraint(equalToConstant: 0)
        
        progressConstraint?.isActive = true
        
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
        outerView.layer.cornerRadius = self.bounds.height/2
        innerView.layer.cornerRadius = self.bounds.height/2
        
        progressConstraint?.constant = progress * self.bounds.width
    }
    
    func config(color: UIColor?, value: Int, maxValue: Int) {
        
        outerView.backgroundColor = Utils.palette.lightGray
        
        innerView.backgroundColor = color
        
        self.progress = CGFloat(value)/CGFloat(maxValue)
        
        
    }
    

}
