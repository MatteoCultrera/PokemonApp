//
//  LoadingVC.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit
import Lottie

class LoadingVC: UIViewController {
    
    var animationView: AnimationView = {
        let animationView = AnimationView(name: "pokeBall")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        setupUI()
    }
    
    
    private func setupUI() {
        
        self.view.addSubview(animationView)
        let size = min(Utils.shared.getWindowSize().width, Utils.shared.getWindowSize().height) * 4 / 5
        animationView.widthAnchor.constraint(equalToConstant: size).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: size).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        animationView.layoutIfNeeded()
        animationView.play()
    }
    
    

}
