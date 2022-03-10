//
//  PokemonDetailedExpandedHeaderView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import Foundation
import UIKit

class PokemonDetailedExpandedHeaderView: UIView {
    
    var images: PokemonImageSet?
    
    var mainImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var setImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        let image = UIImage(named: "image-gallery")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Utils.palette.whiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func buttonTapped() {
        PickerMenuView<ImageVariants>.showPicker(view: setImageButton, configuration: PickerMenuViewConfiguration(), onItemSelected: {[weak self] variant in
            guard let self = self else { return }
            self.switchImage(newImage: variant)
        }, checkValidity: { [weak self] type in
            guard let self = self else { return false }
            switch type {
            case .sprite:
                return self.images?.spriteImage != nil
            case .female:
                return self.images?.defaultFemale != nil
            case .male:
                return self.images?.defaultImage != nil
            case .maleShiny:
                return self.images?.shinyImage != nil
            case .femaleShiny:
                return self.images?.shinyFemale != nil
            case .originalArtwork:
                return self.images?.officialArtwork != nil
            }
            
        })
    }
    
    private func switchImage(newImage: ImageVariants) {
        var newImg: UIImage? = nil
        switch newImage {
        case .sprite:
            newImg = self.images?.spriteImage
        case .female:
            newImg = self.images?.defaultFemale
        case .male:
            newImg = self.images?.defaultImage
        case .maleShiny:
            newImg = self.images?.shinyImage
        case .femaleShiny:
            newImg = self.images?.shinyFemale
        case .originalArtwork:
            newImg = self.images?.officialArtwork
        }
        
        UIView.transition(with: self.mainImageView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self = self else { return }
            self.mainImageView.image = newImg })
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(with images: PokemonImageSet) {
        self.mainImageView.image = images.getDefaultImage()
        setImageButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.images = images
    }
    
    func setupUI() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    
        self.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            mainImageView.widthAnchor.constraint(equalTo: self.heightAnchor),
            mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(setImageButton)
        NSLayoutConstraint.activate([
            setImageButton.widthAnchor.constraint(equalToConstant: 40),
            setImageButton.heightAnchor.constraint(equalToConstant: 40),
            setImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: setImageButton.trailingAnchor, constant: 20)
        ])
    }
    
    
}
