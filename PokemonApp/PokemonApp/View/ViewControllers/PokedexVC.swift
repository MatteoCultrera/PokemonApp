//
//  PokedexVC.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import UIKit

class PokedexVC: UIViewController {
    
    public var coordinator: MainCoordinator!
    
    public enum States {
        case pokemon
        case searching
    }
    
    private var state: States = .pokemon
    private let parallaxInitialHeight = Utils.shared.getWindowSize().height/4
    private let parallaxMinHeight = Utils.shared.getWindowSize().height/10
    
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    
    private var pokemonDataSource: PokedexPokemonDataSource!
    private var searchDataSource: PokedexSearchDataSource!
    
    public var pokedexViewModel: PokedexViewModel!
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        Utils.shared.windowSize = size
        tableView.reloadData()
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsLayoutMarginsFromSafeArea = false
        tableView.tableHeaderView = nil
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        return tableView
    }()
    
    private var searchBar: SearchBarHeaderView = {
       let searchBar = SearchBarHeaderView()
    
        return searchBar
    }()

    private var parallaxView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "pokeBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.insetsLayoutMarginsFromSafeArea = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        setupViewModel()
    }
    
    private func setupViewModel() {
        
       pokedexViewModel.bindPokemonViewModelToController = { [weak self] in
           guard let self = self else { return }
            self.updateDataSource(with: .pokemon)
        }
        
        pokedexViewModel.bindPokemonViewModelSearchToController = { pokemon in
            self.updateDataSource(with: .searching)
        }
        
        
    }
    
    private func setupUI() {
        self.view.insetsLayoutMarginsFromSafeArea = false
        setupParallaxHeader()
        setupTableView()
    }
    
    private func updateDataSource(with state: States) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .pokemon:
                self.pokemonDataSource = PokedexPokemonDataSource(
                    items: self.pokedexViewModel.pokemonList,
                    canLoadMorePokemon: self.pokedexViewModel.canLoadMorePokemon,
                    paddingTopCell: self.parallaxInitialHeight,
                    tableView: self.tableView)
                self.tableView.dataSource = self.pokemonDataSource
                self.pokemonDataSource.delegate = self
            case .searching:
                self.searchDataSource = PokedexSearchDataSource(
                    items: self.pokedexViewModel.searchList,
                    paddingTopCell: self.parallaxInitialHeight,
                    tableView: self.tableView)

                self.tableView.dataSource = self.searchDataSource
                self.searchDataSource.delegate = self
            }
            
            //changing state to search, do not animate
            if self.state != state, state == .searching {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
            } //changing state to pokemon, animate
            else if (self.state != state && state == .pokemon) || (self.state == state && state == .searching){
                
                if #available(iOS 13.0, *) {
                    UIView.transition(with: self.tableView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.tableView.reloadData() })
                } else {
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.reloadData()
            }
            self.state = state
        }
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.delegate = self
                
        updateDataSource(with: .pokemon)
    }
    
    private func setupParallaxHeader() {
        self.view.addSubview(parallaxView)
        
        parallaxView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        parallaxView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        parallaxView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive  = true
        imageHeightConstraint = NSLayoutConstraint(item: parallaxView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: parallaxInitialHeight + 15)
        if let h = imageHeightConstraint {
            parallaxView.addConstraint(h)
        }
        setupBackgroundParallax()
    }
    
    private func setupBackgroundParallax() {
        
        let view = UIView()
        view.backgroundColor = Utils.palette.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.topAnchor.constraint(equalTo: parallaxView.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

extension PokedexVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 73
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 { return nil }
        
        searchBar.config(with: SearchBarHeaderViewConfiguration(
            title: "Pokedex",
            placeholderText: "Search Pokemon"))
        searchBar.delegate = self
        return searchBar
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        imageHeightConstraint?.constant = max(parallaxInitialHeight - offset.y + 15, parallaxMinHeight)
        
        var index: CGFloat = 0
        
        if offset.y < 0 {
            index = 0
        } else if offset.y > parallaxInitialHeight {
            index = 1
        } else {
            index = offset.y/parallaxInitialHeight
        }
        self.searchBar.updateHeader(with: index)
    }
}

extension PokedexVC: SearchBarTextChangeDelegate{
    
    func didTapFilters() {
        let filters = FiltersVC()
        
        let navigation = UINavigationController(rootViewController: filters)
        navigation.modalPresentationStyle = .pageSheet
        navigation.navigationItem.largeTitleDisplayMode = .always
        filters.delegate = self
        self.present(navigation, animated: true, completion: nil)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.tableView.indexPathsForVisibleRows?.first(where: {index in
            return index.section == 0
        }) != nil {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.pokedexViewModel.setSearchText(search: textField.text ?? "")
            })
            
        } else {
            self.pokedexViewModel.setSearchText(search: textField.text ?? "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textFieldText = textField.text else {
            self.pokedexViewModel.setSearchText(search: nil)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            if !textFieldText.isEmpty, textFieldText == self.pokedexViewModel.searchText {
                return
            }
            
            self.pokedexViewModel.setSearchText(search: (textFieldText.isEmpty ? nil : textFieldText))
        })
        
    }
    
    func textFieldDidChangeText(newText: String) {
        self.pokedexViewModel.setSearchText(search: newText)
    }
    
}

extension PokedexVC: PokedexPokemonDataSourceDelegate {
    func goToPokemon(with pokemon: Pokemon) {
        coordinator.presentPokemonDetail(from: self, with: pokemon)
    }
    
    func loadMorePokemon() {
        self.pokedexViewModel.searchPokemon()
    }
    
}

extension PokedexVC: FiltersVCDelegate {
    func filtersVCDidSelectGeneration(generation: PokemonGeneration) {
        self.pokedexViewModel.updateFilter(with: Filter.generation(generation))
        self.searchBar.setFilterImage(image: generation.getImage())
    }
    
    func filtersVCDidClearFilters() {
        self.pokedexViewModel.updateFilter(with: Filter.none)
        self.searchBar.resetFilterButton()
    }
    
    func filtersVCDidSelectType(type: PokemonType) {
        self.pokedexViewModel.updateFilter(with: Filter.type(type))
        self.searchBar.setFilterImage(image: type.getImage())
    }
    
}

extension PokedexVC: PokedexSearchDelegate {
    func userDidTapOnPokemon(name: String, url: String) {
        coordinator.presentPokemonDetail(from: self, with: name, url: url)
    }
}
