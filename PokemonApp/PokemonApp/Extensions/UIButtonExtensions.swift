//
//  UIButtonExtensions.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation
import UIKit

extension UIButton {
    
    func addFadeAnimationPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown])
        addTarget(self, action: #selector(animateUp), for: [.touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, alpha: 0.5)
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, alpha: 1)
    }
    
    private func animate(_ button: UIButton, alpha: CGFloat) {
        button.alpha = alpha
        
    }
    
}
