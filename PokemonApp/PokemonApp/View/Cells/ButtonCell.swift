//
//  ButtonCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import UIKit

protocol ButtonCellDelegate: AnyObject {
    func didTapOnButton()
}

class ButtonCell: UITableViewCell {
    
    weak var delegate: ButtonCellDelegate?
    
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Clear Filter".uppercased(), attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor : UIColor.white]), for: .normal)
        
        button.addFadeAnimationPressActions()
        button.backgroundColor = Utils.palette.accentureColor
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50)
            configuration.cornerStyle = .capsule
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
        
        return button
    }()
    
    @objc func buttonTapped() {
        delegate?.didTapOnButton()
    }

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
        self.contentView.addSubview(button)
        self.backgroundColor = .clear
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            self.contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: Utils.shared.getWindowSize().height/15)
        ])
        button.layer.cornerRadius = Utils.shared.getWindowSize().height/30
        
    }
    
    public func config() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
    }
    

}
