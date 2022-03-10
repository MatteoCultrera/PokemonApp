//
//  PokemonNotFoundVC.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 10/03/22.
//

import UIKit
import Lottie

class PokemonNotFoundVC: UIViewController {
    
    var blurButtonClose: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let closeImage = UIImageView()
        closeImage.image = UIImage(named: "xmark")?.withRenderingMode(.alwaysTemplate)
        closeImage.contentMode = .scaleAspectFit
        closeImage.tintColor = .white
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        
        let _ = ConstraintGroup(superView: container, subView: blurEffectView)
        let c = ConstraintGroup(superView: container, subView: closeImage)
        c.setConstraints(with: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        container.isUserInteractionEnabled = true
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    
    var blurBackground: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.numberOfLines = 0
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        return title
    }()
    var subtitleLabel: UILabel = {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        subtitle.setContentCompressionResistancePriority(.required, for: .vertical)
        return subtitle
    }()
    
    var squirtleAnim: AnimationView = {
        let animation = AnimationView(name: "67858-pokemon")
        animation.loopMode = .loop
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFit
        return animation
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    public func config(with name: String) {
        
        if name.lowercased() == "squirtle" {
            titleLabel.text = "Oh no!\nLooks like \(name) flee\nDon't worry, this one will not go anywhere"
        } else {
            titleLabel.text = "Oh no!\nLooks like \(name) flee\nHere's a cool Squirtle to cheer you up"
        }
        subtitleLabel.text = "Check your internet connection and try again."
        squirtleAnim.play()
    }
    
    private func setupUI() {
        
        let _ = ConstraintGroup(superView: self.view, subView: blurBackground)
        
        self.view.addSubview(blurButtonClose)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            blurButtonClose.widthAnchor.constraint(equalToConstant: 30),
            blurButtonClose.heightAnchor.constraint(equalToConstant: 30),
            blurButtonClose.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            blurButtonClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
        ])
        
        
        blurButtonClose.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        blurButtonClose.addGestureRecognizer(tap)
        
        let c = ConstraintGroup(superView: self.view, subView: squirtleAnim, addBottom: false)
        c.setConstraints(with: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        
        let c2 = ConstraintGroup(superView: self.view, subView: titleLabel, addTop: false, addBottom: false)
        c2.setConstraints(with: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
        
        titleLabel.topAnchor.constraint(equalTo: squirtleAnim.bottomAnchor, constant: 30).isActive = true
        
        let c3 = ConstraintGroup(superView: self.view, subView: subtitleLabel, addTop: false)
        c3.setConstraints(with: UIEdgeInsets(top: 0, left: 50, bottom: 150, right: 50))
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc func closeVC(){
        
        if let nav = self.navigationController {
            nav.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true , completion: nil)
        }
    }
    

}
