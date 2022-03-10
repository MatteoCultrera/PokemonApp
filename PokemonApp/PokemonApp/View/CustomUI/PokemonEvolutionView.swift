//
//  PokemonEvolutionView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import UIKit

protocol PokemonEvolutionViewDelegate: AnyObject {
    func delegateDidTapOnPokemon(pokemon: PokemonShort)
}

class PokemonEvolutionView: UIView {
    
    private var pokemonImage: UIImage? = nil
    private var pokemon: PokemonShort!
    private var recognizer: UILongPressGestureRecognizer?
    
    var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.palette.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 4
        
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var spriteImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = false
        return image
    }()
    
    private var chevron: UIImageView = {
        let chevron = UIImageView()
        let image = UIImage(named: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        chevron.image = image
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = Utils.palette.lightGray
        chevron.contentMode = .scaleAspectFill
        chevron.clipsToBounds = false
        chevron.isUserInteractionEnabled = false
        return chevron
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        
        label.numberOfLines = 0
        
        return label
    }()
    
    weak var delegate: PokemonEvolutionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(with pokemon: PokemonShort) {
        
        label.text = pokemon.name.replacingOccurrences(of: "-", with: " ").capitalized
        
        DataManager.shared.getCachedPokemonImage(from: pokemon.pokemonSpriteUrl, completion: {[weak self] image in
            guard let self = self else { return}
            self.pokemonImage = image
            self.layoutSubviews()
        }, onError: {
            
        })
        self.pokemon = pokemon
    }
    
    @objc func viewTapped(tap: UILongPressGestureRecognizer) {
        switch tap.state {
        case .began:
            self.tap(tapped: true)
        case .ended:
            self.tap(tapped: false)
            delegate?.delegateDidTapOnPokemon(pokemon: pokemon)
        case .cancelled, .failed:
            self.tap(tapped: false)
        case .changed:
            //Cancel tap
            recognizer?.isEnabled = false
            recognizer?.isEnabled = true
        default:
            break
        }
    }
    
  
    
    private func tap(tapped: Bool) {
        
        cardView.transform = tapped ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.1,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.cardView.transform = tapped ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        })
        
        
    }
    
    private func setupUI() {
        
        self.clipsToBounds = false
        self.addSubview(cardView)
        self.backgroundColor = .clear
        let _ = ConstraintGroup(superView: self, subView: cardView)
        
        cardView.addSubview(spriteImage)
        cardView.clipsToBounds = false
        self.isUserInteractionEnabled = true
        cardView.isUserInteractionEnabled = true
        cardView.isExclusiveTouch = false
        
        NSLayoutConstraint.activate([
            spriteImage.widthAnchor.constraint(equalToConstant: 48),
            spriteImage.heightAnchor.constraint(equalToConstant: 48),
            spriteImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spriteImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        ])
        
        cardView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: spriteImage.trailingAnchor, constant: 15),
            label.topAnchor.constraint(equalTo: cardView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 75)
        
        ])
        label.isUserInteractionEnabled = false
        
        cardView.addSubview(chevron)
        NSLayoutConstraint.activate([
            chevron.widthAnchor.constraint(equalToConstant: 15),
            chevron.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            chevron.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20)
        ])
        recognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped))
        recognizer?.delegate = self
        if let recognizer = recognizer {
            recognizer.minimumPressDuration = 0
            cardView.addGestureRecognizer(recognizer)
        }
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = pokemonImage{
            spriteImage.stopShimmerAnimation()
            spriteImage.layer.cornerRadius = 0
            spriteImage.image = image
        } else {
            spriteImage.startShimmerAnimation()
            spriteImage.layer.cornerRadius = spriteImage.bounds.height/2
        }
    }

}

extension PokemonEvolutionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
