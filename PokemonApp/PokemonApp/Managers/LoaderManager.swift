//
//  LoaderManager.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//


import Foundation
import UIKit
import Lottie

class LoaderManager{
    
    static var loaderShown = false
    
    static func showLoader(from viewController: UIViewController) {
        if loaderShown { return }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Utils.shared.getWindowSize().width, height: Utils.shared.getWindowSize().height))
        
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: Utils.shared.getWindowSize().width, height: Utils.shared.getWindowSize().height))
        view.backgroundColor = .clear
        view.alpha = 1
        background.backgroundColor = .black
        background.alpha = 0.7
        
        let animationView = AnimationView(name: "pokeBall")
        
        let size = min(Utils.shared.getWindowSize().width, Utils.shared.getWindowSize().height) / 3
        
        animationView.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: size, height: size)
        view.addSubview(background)
        view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        animationView.layoutIfNeeded()
        animationView.alpha = 1
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: size),
            animationView.heightAnchor.constraint(equalToConstant: size)
        ])
        
        view.tag = 123
        
        viewController.view.addSubview(view)
        
        LoaderManager.loaderShown = true
    }
    
    static func hideLoader(from viewController: UIViewController){
        if !loaderShown { return }
        
        if let view = viewController.view.subviews.filter({$0.tag == 123}).first {
            view.removeFromSuperview()
        }
        LoaderManager.loaderShown = false
    }
    
    
}

