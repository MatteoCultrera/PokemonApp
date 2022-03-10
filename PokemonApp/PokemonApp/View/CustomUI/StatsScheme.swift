//
//  StatsScheme.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 08/03/22.
//

import Foundation
import UIKit

class StatsScheme: UIView {
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(with configuration: StatsSchemeConfiguration) {
        for stat in configuration.stats {
            addProgressView(stat: stat)
        }
    }
    
    private func setupUI(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let _ = ConstraintGroup(superView: self, subView: stackView)
        
        
    }
    
    private func addProgressView(stat: Stat) {
        let view = ProgressView()
        view.config(color: stat.getColor(), value: stat.getStat(), maxValue: Utils.maxStat)
        let innerStack = UIStackView()
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        innerStack.axis = .horizontal
        innerStack.distribution = .fill
        innerStack.alignment = .center
        let firstLabel = UILabel()
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        firstLabel.text = stat.getText()
        firstLabel.textColor = stat.getColor()
        firstLabel.numberOfLines = 0
        firstLabel.setContentHuggingPriority(.required, for: .vertical)
        firstLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        innerStack.addArrangedSubview(firstLabel)
        let secondLabel = UILabel()
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        secondLabel.text = "\(stat.getStat())"
        secondLabel.textColor = stat.getColor()
        secondLabel.numberOfLines = 1
        innerStack.addArrangedSubview(secondLabel)
        innerStack.addArrangedSubview(view)
        innerStack.spacing = 16
        secondLabel.centerXAnchor.constraint(equalTo: innerStack.centerXAnchor, constant: -40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        stackView.addArrangedSubview(innerStack)
    }
    
    
}

struct StatsSchemeConfiguration {
    let stats: [Stat]
}
