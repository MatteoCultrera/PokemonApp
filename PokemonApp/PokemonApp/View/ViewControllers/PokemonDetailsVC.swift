//
//  PokemonDetailsVC.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation
import UIKit

class PokemonDetailsVC: UIViewController {
    
    public var pokemonViewModel: PokemonViewModel!
    
    public weak var coordinator: MainCoordinator?
    
    public var hasImages: Bool = false
    
    private let parallaxInitialHeight = Utils.shared.getWindowSize().height * 0.4
    private let parallaxMinHeight: CGFloat = 60 + Utils.statusBarHeight + 44
    private let parallaxPadding:CGFloat = 44
    
    private var dataSource: PokemonDataSource!
    private var headerHeightConstraint: NSLayoutConstraint?
    
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
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsLayoutMarginsFromSafeArea = false
        tableView.tableHeaderView = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        return tableView
    }()
    
    private var headerBackground: PokemonDetailsHeaderView = {
       
        let view = PokemonDetailsHeaderView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utils.palette.darkGray
        self.hasImages = pokemonViewModel.hasImages
        setupUI()
    }
    
    func setupUI() {
        
        setupTableView()
        setupHeader()
    
        self.navigationController?.isNavigationBarHidden = true
        
        
        self.view.addSubview(blurButtonClose)
        
        
        NSLayoutConstraint.activate([
            blurButtonClose.widthAnchor.constraint(equalToConstant: 30),
            blurButtonClose.heightAnchor.constraint(equalToConstant: 30),
            blurButtonClose.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            blurButtonClose.topAnchor.constraint(equalTo: view.topAnchor, constant: Utils.statusBarHeight + 25)
        ])
        
        
        blurButtonClose.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        blurButtonClose.addGestureRecognizer(tap)
    }
    
    func setupTableView() {
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.dataSource = PokemonDataSource(
            pokemon: pokemonViewModel.pokemonDetailed,
            paddingTopCell: pokemonViewModel.hasImages ? parallaxInitialHeight : parallaxMinHeight,
            tableView: tableView)
        self.dataSource.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self.dataSource
    }
    
    func setupHeader() {
        
        self.view.addSubview(headerBackground)
        
        headerBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerHeightConstraint = headerBackground.heightAnchor.constraint(equalToConstant: hasImages ? parallaxInitialHeight : parallaxMinHeight)
        headerHeightConstraint?.isActive = true
        headerBackground.config(
            with: PokemonDetailsHeaderViewConfiguration(
                type: pokemonViewModel.mainType,
                name: pokemonViewModel.pokemonDetailed.name,
                navBarHeader: parallaxMinHeight - parallaxPadding,
                bottomPadding: parallaxPadding,
                images: pokemonViewModel.pokemonDetailed.imageSet))
        if !hasImages {
            headerBackground.hideImageButton()
        }
        
        self.view.bringSubviewToFront(headerBackground)
    }
    
    @objc func closeVC(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

extension PokemonDetailsVC: UITableViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        let space = parallaxInitialHeight - offset
        var scrollIndex: CGFloat = 1
        var secondaryIndex: CGFloat = 1
        var onlyCollapsedIndex: CGFloat = 0
        
        onlyCollapsedIndex = max(0, 1 - offset/parallaxMinHeight)
        onlyCollapsedIndex = min(1, onlyCollapsedIndex)
        
        if offset < 0 {
            scrollIndex = 1
            secondaryIndex = 1
        } else if space < parallaxMinHeight {
            scrollIndex = 0
            secondaryIndex = space / parallaxMinHeight
            if secondaryIndex < 0 {
                secondaryIndex = 0
            }
        } else {
            scrollIndex = (space - parallaxMinHeight) / (parallaxInitialHeight - parallaxMinHeight)
            secondaryIndex = 1
        }
        
        if hasImages {
            headerHeightConstraint?.constant = max(parallaxInitialHeight - offset, parallaxMinHeight)
            headerBackground.updateExpandedView(index: scrollIndex)
            headerBackground.updateCollapsedView(index: secondaryIndex)
        } else {
            headerBackground.updateCollapsedView(index: onlyCollapsedIndex)
        }
        
        
        
    }
    
    
}

extension PokemonDetailsVC: PokemonDataSourceDelegate {
    func pokemonTapped(pokemon: PokemonShort) {
        guard let nav = self.navigationController else {
            return
        }
        
        coordinator?.pushPokemonDetailed(from: nav, with: pokemon.name, url: pokemon.url)
        
    }
}
