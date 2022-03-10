//
//  PaddedTextField.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

class PaddedTextField: UITextField {
    
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    
    private var height: CGFloat {
        return font?.lineHeight ?? 20
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + textInsets.left, y: bounds.origin.y, width: bounds.width - textInsets.right * 2 - (rightView == nil ? 0 : textInsets.right + 20), height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + textInsets.left, y: bounds.origin.y, width: bounds.width - textInsets.right * 2 - (rightView == nil ? 0 : textInsets.right + 20), height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 40, y: (bounds.height - height)/2, width: 20, height: 20)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return rightViewRect(forBounds: bounds)
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: height + textInsets.top + textInsets.bottom)
    }
    
    func searchBarHeight() -> CGFloat {
        return height + textInsets.top + textInsets.bottom
    }
    
}
