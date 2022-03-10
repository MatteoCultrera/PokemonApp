//
//  TypeView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit

class TypeView: UIView {
    
    var type: PokemonType? = nil
    
    private var shimmer: Bool = false
    
    private var typeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var typeLabel: UILabel = {
        
        let labelView = UILabel()
        labelView.numberOfLines = 0
        labelView.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        labelView.textColor = .white
        labelView.adjustsFontSizeToFitWidth = true
        labelView.textAlignment = .center
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        return labelView
    }()
    
    private var shimmerView: UIView = {
        let shimmer = UIView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        shimmer.backgroundColor = .clear
        shimmer.layer.masksToBounds = true
        return shimmer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.addSubview(typeImage)
        NSLayoutConstraint.activate([
            typeImage.topAnchor.constraint(equalTo: self.topAnchor),
            typeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            typeImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            typeImage.widthAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        self.addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: typeImage.trailingAnchor, constant: 5),
            self.trailingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10)
        ])
        
        self.addSubview(shimmerView)
        NSLayoutConstraint.activate([
            shimmerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shimmerView.topAnchor.constraint(equalTo: self.topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        
        if shimmer {
            shimmerView.startShimmerAnimation()
            self.layer.borderWidth = 0
        } else {
            shimmerView.stopShimmerAnimation()
            self.backgroundColor = type?.getColor().withAlphaComponent(0.5)
            self.typeImage.image = type?.getImage()
            self.layer.borderWidth = 1
            self.layer.borderColor = type?.getColor().cgColor
            self.typeLabel.text = type?.rawValue.uppercased()
        }
    }
    
    func setupForShimmer() {
        self.shimmer = true
    }
    
    func setup(with type: PokemonType) {
        self.shimmer = false
        self.type = type
        self.layoutSubviews()
    }

}
