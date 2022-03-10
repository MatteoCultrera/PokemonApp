//
//  SearchBarHeaderView.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit

protocol SearchBarTextChangeDelegate: AnyObject {
    func textFieldDidChangeText(newText: String)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func didTapFilters()
}

class SearchBarHeaderView: UIView {
    
    weak var delegate: SearchBarTextChangeDelegate?
    
    private var filterViewMaxWidth: CGFloat = 0

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var filterView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var filterButton: UIButton = {
        
        let filter = UIButton()
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filter.addFadeAnimationPressActions()
        filter.contentMode = .scaleToFill
        
        let image = UIImage(named: "filterImage")?.withRenderingMode(.alwaysTemplate)
        
        filter.setImage(image, for: .normal)
        filter.tintColor = .white
        
        return filter
    }()
    
    
    private var filterWidthConstraint: NSLayoutConstraint? = nil
    
    private var state: PokedexVC.States = .pokemon {
        didSet{
            if state != oldValue {
                
                self.filterButton.alpha = self.state == .pokemon ? 0 : 1
                if let width = self.filterWidthConstraint {
                    width.constant = (self.state == .pokemon ? self.filterViewMaxWidth : 0)
                }
                
                UIView.animate(withDuration: 0.35,
                               animations: {
                    self.layoutSubviews()
                    self.filterButton.alpha = self.state == .pokemon ? 1 : 0
                })
                
            }
        }
    }
    
    private var searchBar: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Utils.palette.darkGray
        textField.layer.cornerRadius = 15
        textField.textColor = .white
        textField.rightViewMode = .always
        return textField
    }()
    
    private var searchImageView: UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.frame.size = CGSize(width: 20, height: 20)
        searchImageView.contentMode = .scaleAspectFill
        searchImageView.image = UIImage(named: "searchGlass")
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        return searchImageView
    }()
    
    private var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clear.fill"), for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func clearButtonTapped() {
        searchBar.text = ""
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        } else {
            self.setTextFieldButton(clear: false, withAnim: false)
            self.layoutIfNeeded()
            self.state = .pokemon
        }
        delegate?.textFieldDidEndEditing(searchBar)
    }
    
    @objc private func filterButtonTapped() {
        delegate?.didTapFilters()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.layer.cornerRadius = searchBar.bounds.height/2
        if filterViewMaxWidth == 0 {
            filterViewMaxWidth = searchBar.bounds.height
        }
    }
    
    public func config(with configuration: SearchBarHeaderViewConfiguration) {
        
        titleLabel.text = configuration.title
        searchBar.placeholder = configuration.placeholderText
        searchBar.delegate = self
        
        searchBar.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        
    }
    
    public func setFilterImage(image: UIImage?) {
        self.filterButton.setImage(image, for: .normal)
    }
    
    @objc func textChanged(_ textField: UITextField) {
        setTextFieldButton(clear: !(textField.text ?? "").isEmpty, withAnim: true)
        delegate?.textFieldDidChangeText(newText: textField.text ?? "")
    }
    
    public func updateHeader(with index: CGFloat) {
        
        self.layer.cornerRadius = (1-index) * 15
        
        
    }
    
    private func setupUI() {
        
        self.backgroundColor = .red
        
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 20 + Utils.statusBarHeight).isActive = true
        
        self.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        
        self.addSubview(filterView)
        
        filterWidthConstraint = NSLayoutConstraint(item: filterView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: searchBar.searchBarHeight())
        if let f = filterWidthConstraint {
            filterView.addConstraint(f)
        }
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            self.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: 10),
            filterView.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            filterView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor)
        ])
        
        filterView.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.heightAnchor.constraint(equalToConstant: searchBar.searchBarHeight() - 20),
            filterButton.widthAnchor.constraint(equalToConstant: searchBar.searchBarHeight() - 20),
            filterButton.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 10),
            filterButton.centerYAnchor.constraint(equalTo: filterView.centerYAnchor)
        ])
        
        self.addSubview(searchImageView)
        
        NSLayoutConstraint.activate([
            searchImageView.heightAnchor.constraint(equalToConstant: 20),
            searchImageView.widthAnchor.constraint(equalToConstant: 20),
            searchBar.trailingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 20),
            searchImageView.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor)
        ])
        
        self.trailingAnchor.constraint(greaterThanOrEqualTo: searchBar.trailingAnchor, constant: 20).isActive = true
        
        self.layer.cornerRadius =  15
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.backgroundColor = Utils.palette.lightGray
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
    }
    
    public func resetFilterButton() {
        let image = UIImage(named: "filterImage")?.withRenderingMode(.alwaysTemplate)
        
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = .white
    }
    
    private func setTextFieldButton(clear: Bool, withAnim: Bool) {
        
        
        if withAnim {
            let subviewToRemove = clear ? self.searchImageView : self.clearButton
            if subviewToRemove.superview != nil {
                UIView.animate(withDuration: 0.15,
                               animations: {
                    subviewToRemove.alpha = 0
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    subviewToRemove.removeFromSuperview()
                    let nextView: UIView = clear ? self.clearButton : self.searchImageView
                    nextView.alpha = 0
                    self.addSubview(nextView)
                    NSLayoutConstraint.activate([
                        nextView.heightAnchor.constraint(equalToConstant: 20),
                        nextView.widthAnchor.constraint(equalToConstant: 20),
                        self.searchBar.trailingAnchor.constraint(equalTo: nextView.trailingAnchor, constant: 20),
                        nextView.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor)
                    ])
                    UIView.animate(withDuration: 0.15,
                                   animations: {
                        nextView.alpha = 1
                    })
                })
            } else {
                let nextView: UIView = clear ? self.clearButton : self.searchImageView
                nextView.alpha = 0
                self.addSubview(nextView)
                NSLayoutConstraint.activate([
                    nextView.heightAnchor.constraint(equalToConstant: 20),
                    nextView.widthAnchor.constraint(equalToConstant: 20),
                    self.searchBar.trailingAnchor.constraint(equalTo: nextView.trailingAnchor, constant: 20),
                    nextView.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor)
                ])
                UIView.animate(withDuration: 0.15,
                               animations: {
                    nextView.alpha = 1
                })
            }
        } else {
            let subviewToRemove = clear ? self.searchImageView : self.clearButton
            subviewToRemove.removeFromSuperview()
            let nextView: UIView = clear ? self.clearButton : self.searchImageView
            self.addSubview(nextView)
            nextView.alpha = 1
            NSLayoutConstraint.activate([
                nextView.heightAnchor.constraint(equalToConstant: 20),
                nextView.widthAnchor.constraint(equalToConstant: 20),
                self.searchBar.trailingAnchor.constraint(equalTo: nextView.trailingAnchor, constant: 20),
                nextView.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor)
            ])
        }
    }

}

public struct SearchBarHeaderViewConfiguration {
    
    public let title: String
    public let placeholderText: String
    
}

extension SearchBarHeaderView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.state = .searching
        delegate?.textFieldDidBeginEditing(textField)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldButton(clear: !(textField.text ?? "").isEmpty, withAnim: false)
        self.layoutIfNeeded()
        self.state = (textField.text ?? "").isEmpty ? .pokemon : .searching
        delegate?.textFieldDidEndEditing(textField)
    }
}
