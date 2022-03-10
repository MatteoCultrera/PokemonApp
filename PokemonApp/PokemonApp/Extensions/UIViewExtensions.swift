//
//  UIViewExtensions.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

extension UIView {
    
    
    func stopShimmerAnimation() {
        
        guard let sublayers = self.layer.sublayers else {
            return
        }
        
        for layer in sublayers {
            if let gradient = layer as? CAGradientLayer, gradient.name == "GradientLayerForShimmer" {
                gradient.removeFromSuperlayer()
            }
        }
    }
    
    
    func startShimmerAnimation() {
        
        if let subLayers = self.layer.sublayers, let layer = subLayers.first(where: { layer in
            guard let gradient = layer as? CAGradientLayer else { return false }
            return gradient.name == "GradientLayerForShimmer"
        }) {
            layer.removeFromSuperlayer()
        }
        
        let gradientColorOne = UIColor(white: 0.45, alpha: 1.0).cgColor
        let gradientColorTwo = UIColor(white: 0.55, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        /* Allocate the frame of the gradient layer as the view's bounds, since the layer will sit on top of the view. */
        
        gradientLayer.frame = self.bounds
        /* To make the gradient appear moving from left to right, we are providing it the appropriate start and end points.
         Refer to the diagram above to understand why we chose the following points.
         */
        gradientLayer.name = "GradientLayerForShimmer"
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo,   gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        /* Adding the gradient layer on to the view */
        self.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        gradientLayer.add(animation, forKey: animation.keyPath)
        animation.repeatCount = .infinity
        animation.speed = 0.3
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
}
