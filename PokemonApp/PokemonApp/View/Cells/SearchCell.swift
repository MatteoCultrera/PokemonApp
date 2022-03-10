//
//  SearchCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit

protocol SearchCellDelegate: AnyObject {
    func pokemonTapped(with indexPath: IndexPath)
}

class SearchCell: UITableViewCell {
    
    private var currentPokemonId: String = "na"
    public var indexPath: IndexPath? = nil
    public weak var delegate: SearchCellDelegate?
    
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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var spriteImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true

        self.contentView.addSubview(spriteImage)

        NSLayoutConstraint.activate([
            spriteImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            spriteImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            spriteImage.heightAnchor.constraint(equalToConstant: 50),
            spriteImage.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 35),
            self.contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 35),
            label.leadingAnchor.constraint(equalTo: spriteImage.trailingAnchor, constant: 15)
        ])
        
        self.contentView.addSubview(chevron)
        NSLayoutConstraint.activate([
            self.contentView.trailingAnchor.constraint(equalTo: chevron.trailingAnchor, constant: 20),
            chevron.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 15),
            chevron.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20)
        ])
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Utils.palette.lightGray

        self.contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        
        self.backgroundColor = Utils.palette.darkGray
        
        spriteImage.startShimmerAnimation()
        spriteImage.layer.cornerRadius = 25
        self.currentPokemonId = "na"
    }
    
    override func prepareForReuse() {
        spriteImage.startShimmerAnimation()
        spriteImage.layer.cornerRadius = 25
        self.currentPokemonId = "na"
    }
    
    public func config(with item: PokemonShort, alignment: NSTextAlignment = .left, indexPath: IndexPath) {
        label.text = item.name.replacingOccurrences(of: "-", with: " ").capitalized
        label.textAlignment = alignment
        self.currentPokemonId = item.id
        self.spriteImage.alpha = 1
        self.chevron.alpha = 1
        
        DataManager.shared.getCachedPokemonImage(from: item.pokemonSpriteUrl, completion: {[weak self] image in
            guard let self = self else { return }
            if self.currentPokemonId != item.id { return }
            self.spriteImage.stopShimmerAnimation()
            self.spriteImage.layer.cornerRadius = 0
            self.spriteImage.image = image
        }, onError: { })
        self.indexPath = indexPath
        let tap = UITapGestureRecognizer(target: self, action: #selector(pokemonTapped))
        self.contentView.addGestureRecognizer(tap)
    }
    
    public func configNotFound() {
        
        label.textAlignment = .left
        label.text = "Pokemon not found"
        self.spriteImage.alpha = 0
        self.chevron.alpha = 0
        self.indexPath = nil
    }
    
    @objc func pokemonTapped() {
        guard let indexPath = indexPath else {
            return
        }

        delegate?.pokemonTapped(with: indexPath)
        
    }

}
