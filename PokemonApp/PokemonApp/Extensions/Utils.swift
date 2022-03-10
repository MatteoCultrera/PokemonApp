//
//  Utils.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

class Utils {
    
    public static var shared: Utils = Utils()
    public var windowSize: CGSize?
    
    func getWindowSize() -> CGSize {
        return windowSize ?? UIScreen.main.bounds.size
    }
    
    static var maxStat: Int = 255
    
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    static var palette: Palette = Palette(
        whiteColor: UIColor.white,
        darkWhiteColor: UIColor(rgb: 0xA1A1A1),
        lightGray: UIColor(rgb: 0x334756),
        mediumGray: UIColor(rgb: 0x2C394B),
        darkGray: UIColor(rgb: 0x082032),
        accentureColor: UIColor(rgb: 0xFF4C29))
}

struct Palette {
    let whiteColor: UIColor
    let darkWhiteColor: UIColor
    let lightGray: UIColor
    let mediumGray: UIColor
    let darkGray: UIColor
    
    let accentureColor: UIColor
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}

struct ConstraintGroup {
    
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    
    //Init to constrain every side of subview to
    //the superview
    init(superView: UIView,
         subView: UIView,
         addTop: Bool = true,
         addBottom: Bool = true,
         addLeading: Bool = true,
         addTrailing: Bool = true) {
        
        if subView.superview != superView {
            superView.addSubview(subView)
        }
        
        if addTop {
            self.topConstraint = subView.topAnchor.constraint(equalTo: superView.topAnchor)
        }
        if addBottom {
            self.bottomConstraint = subView.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        }
        if addLeading {
            self.leadingConstraint = subView.leadingAnchor.constraint(equalTo: superView.leadingAnchor)
        }
        if addTrailing{
            self.trailingConstraint = subView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        }
        
        activateAllConstraint()
        
    }
    
    //Default Init
    init(topConstraint: NSLayoutConstraint? = nil, bottomConstraint: NSLayoutConstraint? = nil, leadingConstraint: NSLayoutConstraint? = nil,
         trailingConstraint: NSLayoutConstraint? = nil) {
        self.topConstraint = topConstraint
        self.bottomConstraint = bottomConstraint
        self.leadingConstraint = leadingConstraint
        self.trailingConstraint = trailingConstraint
    }
    
    func activateAllConstraint() {
        self.topConstraint?.isActive = true
        self.bottomConstraint?.isActive = true
        self.leadingConstraint?.isActive = true
        self.trailingConstraint?.isActive = true
    }
    
    func deactivateAllConstraint() {
        self.topConstraint?.isActive = false
        self.bottomConstraint?.isActive = false
        self.leadingConstraint?.isActive = false
        self.trailingConstraint?.isActive = false
    }
    
    func setConstraints(with insets: UIEdgeInsets) {
        self.topConstraint?.constant = insets.top
        self.bottomConstraint?.constant = -insets.bottom
        self.leadingConstraint?.constant = insets.left
        self.trailingConstraint?.constant = -insets.right
    }
    
    
}
