//
//  PokedexPokemonCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 05/03/22.
//

import UIKit

protocol PokedexPokemonCellDelegate: AnyObject {
    func didTapOnCard(at index: IndexPath?)
}

class PokedexPokemonCell: UITableViewCell {
    
    private var configuration: PokedexPokemonCellConfiguration?
    private var shimmerImage: UIImage?
    
    public var indexPath: IndexPath?
    
    weak var delegate: PokedexPokemonCellDelegate?
    
    private var imageWidth: NSLayoutConstraint?
    private var imageHeight: NSLayoutConstraint?
    
    private var typesWidth: NSLayoutConstraint?
    
    private enum State {
        case shimmer
        case configured
        case error
    }
    
    private var state: PokedexPokemonCell.State = .shimmer
    
    private var pokemonNameLabel: UILabel = {
        let cell = UILabel()
        cell.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        cell.textColor = .white
        cell.isUserInteractionEnabled = false
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.numberOfLines = 4
        return cell
    }()

    private var cardView: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = Utils.palette.lightGray
        card.layer.cornerRadius = 25
        
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 10)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 10
        
        card.clipsToBounds = true
        card.isUserInteractionEnabled = true
        
        return card
    }()
    
    private var shadowView: UIView = {
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.backgroundColor = .black
        shadow.layer.cornerRadius = 25
        
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadow.layer.shadowOpacity = 0.4
        shadow.layer.shadowRadius = 10
        
        shadow.clipsToBounds = false
        return shadow
    }()
    
    private var typesStackView: TypesStackView = {
        let types = TypesStackView()
        types.isUserInteractionEnabled = false
        return types
    }()
    
    private var shimmerSpriteView: UIView = {
        
        let shimmerView = UIView()
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        shimmerView.backgroundColor = Utils.palette.mediumGray
        return shimmerView
    }()
    
    private var pokemonSpriteView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        shimmerSpriteView.startShimmerAnimation()
        typesStackView.setupForShimmer()
        pokemonSpriteView.alpha = 0
    }
    
    @objc func cardTapped() {
        delegate?.didTapOnCard(at: indexPath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageWidth?.constant = Utils.shared.getWindowSize().width/5
        imageHeight?.constant = Utils.shared.getWindowSize().width/5
        typesWidth?.constant = Utils.shared.getWindowSize().width/5
        
        switch state {
        case .shimmer:
            shimmerSpriteView.alpha = 1
            shimmerSpriteView.startShimmerAnimation()
            pokemonSpriteView.alpha = 0
            typesStackView.setupForShimmer()
            pokemonNameLabel.text = "Loading..."
        case .configured:
            if let imageUrl = configuration?.pokemonImageUrl {
                
                DataManager.shared.getCachedPokemonImage(from: imageUrl, completion: {
                    [weak self] image in
                    guard let self = self, let newUrl = self.configuration?.pokemonImageUrl, newUrl == imageUrl else { return }
                    self.shimmerSpriteView.stopShimmerAnimation()
                    self.pokemonSpriteView.alpha = 1
                    self.pokemonSpriteView.image = image
                    if let color = self.configuration?.pokemonTypes.first?.getColor() {
                        self.shimmerSpriteView.backgroundColor = color
                        self.shimmerSpriteView.alpha = 0.5
                    }
                }, onError: { })
                
            }
            
            guard let configuration = configuration else {
                return
            }
            
            typesStackView.setup(with: configuration.pokemonTypes)
            pokemonNameLabel.text = configuration.pokemonName.replacingOccurrences(of: "-", with: " ").capitalized
        case .error:
            break
        }
        
    }
    
    public func config(with configuration: PokedexPokemonCellConfiguration) {
        self.state = .configured
        self.configuration = configuration
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        cardView.addGestureRecognizer(tap)
        layoutSubviews()
    }
    
    public func configShimmer() {
        self.state = .shimmer
        layoutSubviews()
    }
    

    private func setupUI(){
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(cardView)
        
        let c = ConstraintGroup(superView: self.contentView, subView: cardView)
        c.setConstraints(with: UIEdgeInsets(top: 30, left: 15, bottom: 0, right: 15))
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: cardView.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        
        ])
        
        cardView.addSubview(shimmerSpriteView)
        NSLayoutConstraint.activate([
            shimmerSpriteView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            shimmerSpriteView.topAnchor.constraint(equalTo: cardView.topAnchor),
          
            shimmerSpriteView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        
        self.contentView.addSubview(pokemonSpriteView)
        
        imageWidth = pokemonSpriteView.widthAnchor.constraint(equalToConstant: Utils.shared.getWindowSize().width/5)
        imageHeight = pokemonSpriteView.heightAnchor.constraint(equalToConstant: Utils.shared.getWindowSize().width/5)
        imageWidth?.isActive = true
        imageHeight?.isActive = true
        
        NSLayoutConstraint.activate([
            pokemonSpriteView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            cardView.bottomAnchor.constraint(equalTo: pokemonSpriteView.bottomAnchor, constant: 30),
            pokemonSpriteView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            shimmerSpriteView.trailingAnchor.constraint(equalTo: pokemonSpriteView.trailingAnchor, constant: 13),
        ])
        
        
        
        self.contentView.addSubview(pokemonNameLabel)
        NSLayoutConstraint.activate([
            pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonSpriteView.trailingAnchor, constant: 28),
            pokemonNameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
        
        
        self.contentView.addSubview(typesStackView)
        
        typesWidth = typesStackView.widthAnchor.constraint(equalToConstant: Utils.shared.getWindowSize().width/5)
        typesWidth?.isActive = true
        
        NSLayoutConstraint.activate([
            typesStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: typesStackView.trailingAnchor, constant: 15),
            typesStackView.leadingAnchor.constraint(equalTo: pokemonNameLabel.trailingAnchor, constant: 15)
        ])
        
        self.backgroundColor = .clear
    }

}

public struct PokedexPokemonCellConfiguration {
    
    let pokemonTypes: [PokemonType]
    let pokemonName: String
    let pokemonImageUrl: String?
    
}
