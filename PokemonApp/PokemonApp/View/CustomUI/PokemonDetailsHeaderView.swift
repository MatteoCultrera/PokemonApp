//
//  PokemonDetailsHeaderView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit

class PokemonDetailsHeaderView: UIView {
    
    private var expandedHeaderViewTopConstraint: NSLayoutConstraint?
    private var expandedHeaderViewBottomConstraint: NSLayoutConstraint?
    private var collapsedHeaderBottomConstraint: NSLayoutConstraint?
    
    private var bottomPadding: CGFloat = 0

    
    private var expandedHeaderView: PokemonDetailedExpandedHeaderView = {
       let view = PokemonDetailedExpandedHeaderView()
        return view
    }()
    
   
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        label.numberOfLines = 2
        return label
    }()
    
    var blurBackground: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func hideImageButton() {
        expandedHeaderView.setImageButton.isEnabled = false
        expandedHeaderView.setImageButton.alpha = 0
    }
    
    func config(with configuration: PokemonDetailsHeaderViewConfiguration) {
        
        self.backgroundColor = configuration.type.getColor().withAlphaComponent(0.5)
        expandedHeaderViewTopConstraint?.constant = configuration.navBarHeader
        expandedHeaderViewBottomConstraint?.constant = configuration.bottomPadding
        
        titleLabel.text = configuration.name.replacingOccurrences(of: "-", with: " ").capitalized
        
        collapsedHeaderBottomConstraint?.constant = 0
        bottomPadding = configuration.bottomPadding
        expandedHeaderView.config(with: configuration.images)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 10
    }
    
    func setupUI(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = false
        
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        let maskView = UIView()
        maskView.translatesAutoresizingMaskIntoConstraints = false
        maskView.backgroundColor = .clear
        maskView.clipsToBounds = true
        self.addSubview(maskView)
        
        maskView.layer.cornerRadius = 30
        maskView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        NSLayoutConstraint.activate([
            maskView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            maskView.topAnchor.constraint(equalTo: self.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        maskView.addSubview(blurBackground)
        NSLayoutConstraint.activate([
            blurBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurBackground.topAnchor.constraint(equalTo: self.topAnchor),
            blurBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        blurBackground.clipsToBounds = true
        
        let labelView = UIView()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.backgroundColor = .clear
        labelView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: labelView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 80),
            titleLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant:  -80)
        ])
        
        maskView.addSubview(labelView)
        
        collapsedHeaderBottomConstraint = labelView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50)
        collapsedHeaderBottomConstraint?.isActive = true
        labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        maskView.addSubview(expandedHeaderView)
        
        expandedHeaderViewTopConstraint = expandedHeaderView.topAnchor.constraint(equalTo: self.topAnchor)
        expandedHeaderViewBottomConstraint = self.bottomAnchor.constraint(equalTo: expandedHeaderView.bottomAnchor)
        expandedHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        expandedHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        expandedHeaderViewTopConstraint?.isActive = true
        expandedHeaderViewBottomConstraint?.isActive = true
        
    }
    
    public func updateExpandedView(index: CGFloat) {
        
        expandedHeaderView.alpha = index
        
        let upTransform = CGAffineTransform(translationX: 0, y: 20 * (1 - index))
        expandedHeaderView.transform = upTransform
    }
    
    public func updateCollapsedView(index: CGFloat) {
        
        collapsedHeaderBottomConstraint?.constant = 50*index - bottomPadding * (1 - index)
        titleLabel.alpha = 1 - index
    }

}

struct PokemonDetailsHeaderViewConfiguration {
    
    let type: PokemonType
    let name: String
    let navBarHeader: CGFloat
    let bottomPadding: CGFloat
    let images: PokemonImageSet
    
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
