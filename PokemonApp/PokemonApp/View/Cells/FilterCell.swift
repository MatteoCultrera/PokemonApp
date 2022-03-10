//
//  FilterCell.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import UIKit

class FilterCell<T: CaseIterable>: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource where T: ImageRepresentable {
    
    private var collectionView: ButtonArrayCollectionView = {
        
        let buttonArray = ButtonArrayCollectionView(with: ButtonArrayCollectionViewConfiguration())
        
        return buttonArray
        
    }()
    
    public var onButtonTapped: (T) -> () = {_ in }
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
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
        self.backgroundColor = .clear
        
        self.contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.contentView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20)
        
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewButtonCell.self, forCellWithReuseIdentifier: "CollectionViewButtonCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        if let h = collectionViewHeightConstraint {
            collectionView.addConstraint(h)
        }
    }
    
    public func config() {
        self.layoutIfNeeded()
        self.collectionView.reloadData()
        self.collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return T.allCases.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewButtonCell", for: indexPath)
        if let button = cell as? CollectionViewButtonCell {
            let item = T.allCases[indexPath.item as! T.AllCases.Index].getImage()
            button.config(index: indexPath.item, with: item)
            button.delegate = self
        }
        return cell
    }
}

extension FilterCell: CollectionViewButtonCellDelegate {
    func collectionButtonTapped(with index: Int) {
        self.onButtonTapped(T.allCases[index as! T.AllCases.Index])
    }
    
    
}

