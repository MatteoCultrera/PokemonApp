//
//  LoadingCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit
import Lottie

class LoadingCell: UITableViewCell {
    
    var animationView: AnimationView = {
        let anim = AnimationView(name: "loadingAnim")
        anim.translatesAutoresizingMaskIntoConstraints = false
        anim.contentMode = .scaleAspectFit
        anim.loopMode = .loop
        return anim
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func config() {
        animationView.play()
    }
    
    override func prepareForReuse() {
        animationView.stop()
    }
    
    private func setupUI(){
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 150),
            animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant:  0),
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
    }

}
