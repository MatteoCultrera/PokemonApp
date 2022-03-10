//
//  EnumTappableButton.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import UIKit


class EnumTappableButton<T: CaseIterable>: UIView where T: ImageRepresentable, T: TextRepresentable, T: ColorRepresentable {

    private var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var label: UILabel = {
        
        let labelView = UILabel()
        labelView.numberOfLines = 0
        labelView.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        labelView.textColor = .white
        labelView.adjustsFontSizeToFitWidth = true
        labelView.textAlignment = .center
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        return labelView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public var type: T!
    
    public var isEnabled = true {
        didSet{
            if isEnabled {
                self.backgroundColor = type.getColor().withAlphaComponent(0.5)
                self.layer.borderColor = type.getColor().cgColor
                self.label.alpha = 1
                self.image.alpha = 1
            } else {
                self.backgroundColor = Utils.palette.lightGray.withAlphaComponent(0.5)
                self.layer.borderColor = Utils.palette.lightGray.cgColor
                self.label.alpha = 0.5
                self.image.alpha = 0.5
            }
        }
    }
    
    var selectedType: (T) -> () = {_ in }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = event?.touches(for: self) else { return }
        super.touchesBegan(touches, with: event)
        if isEnabled {
            self.alpha = 0.5
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = event?.touches(for: self) else { return }
        super.touchesEnded(touches, with: event)
        if isEnabled {
            self.alpha = 1
            self.selectedType(type)
        }
    }
    
    private func setupUI() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height/2
        
        self.addSubview(image)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalTo: self.heightAnchor),
            image.widthAnchor.constraint(equalTo: self.heightAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            self.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10)
        ])
        
        
    }
    
    public func config(type: T, isEnabled: Bool) {
        self.type = type
        
        
        self.layer.borderWidth = 1
        self.isEnabled = isEnabled
        
        
        self.image.image = type.getImage()
        self.label.text = type.getText()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height/2
    }

}
