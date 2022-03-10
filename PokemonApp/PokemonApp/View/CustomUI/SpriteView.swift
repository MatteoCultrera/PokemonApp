//
//  SpriteView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit

class SpriteView: UIImageView {
    
    private var shimmering: Bool = false
    
    convenience init(shimmer: Bool) {
        self.init(frame: .zero)
        self.shimmering = shimmer
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
}
