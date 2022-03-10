//
//  FiltersVC.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 07/03/22.
//

import Foundation
import UIKit

protocol FiltersVCDelegate: AnyObject {
    
    func filtersVCDidSelectType(type: PokemonType)
    func filtersVCDidSelectGeneration(generation: PokemonGeneration)
    func filtersVCDidClearFilters()
}

class FiltersVC: UIViewController {
    
    weak var delegate: FiltersVCDelegate?
    
    enum CellType {
        case label(text: String)
        case typeButtons
        case genButtons
        case clearAll
    }
    
    private var dataSource: [CellType]!
    
    var blurBackground: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [
            .label(text: "Select Type"),
            .typeButtons,
            .label(text: "Select Generation"),
            .genButtons,
            .clearAll
        ]
        
        setupUI()
    }
    
    private func setupUI() {
        
        self.navigationItem.title = "Filters"
        
        if #available(iOS 13.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let scrollAppearance = UINavigationBarAppearance()
            scrollAppearance.configureWithTransparentBackground()
            scrollAppearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
            let collapsedAppearance = UINavigationBarAppearance()
            collapsedAppearance.backgroundEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            collapsedAppearance.backgroundColor = .clear
            collapsedAppearance.titleTextAttributes = [.foregroundColor : UIColor.white]
            self.navigationItem.scrollEdgeAppearance = scrollAppearance
            self.navigationItem.compactAppearance = collapsedAppearance
            self.navigationItem.standardAppearance = collapsedAppearance
        } else {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.barTintColor = .black
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        }
        
        
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.backgroundView = blurBackground
        
        tableView.register(FilterCell<PokemonType>.self, forCellReuseIdentifier: "FilterCellType")
        tableView.register(FilterCell<PokemonGeneration>.self, forCellReuseIdentifier: "FilterCellGeneration")
        tableView.register(LabelCell.self, forCellReuseIdentifier: "LabelCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
        
    }
    
}

extension FiltersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch dataSource[indexPath.row] {
        case .label(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") ?? LabelCell(style: .default, reuseIdentifier: "LabelCell")
            if let label = cell as? LabelCell {
                label.config(
                    with: LabelCellConfiguration(
                        title: NSAttributedString(string: text, attributes: [ .font : UIFont.systemFont(ofSize: 25, weight: .bold), .foregroundColor : UIColor.white]),
                        insets: UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20), alignment: .left, numLines: 1))
            }
            return cell
        case .typeButtons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCellType") ?? FilterCell<PokemonType>(style: .default, reuseIdentifier: "FilterCellType")
            if let buttons = cell as? FilterCell<PokemonType> {
                cell.frame = tableView.bounds
                cell.layoutIfNeeded()
                buttons.config()
                buttons.onButtonTapped = { [weak self] button in
                    guard let self = self else { return }
                    self.delegate?.filtersVCDidSelectType(type: button)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            return cell
        case .genButtons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCellGeneration") ?? FilterCell<PokemonGeneration>(style: .default, reuseIdentifier: "FilterCellGeneration")
            if let buttons = cell as? FilterCell<PokemonGeneration> {
                cell.frame = tableView.bounds
                cell.layoutIfNeeded()
                buttons.config()
                buttons.onButtonTapped = { [weak self] button in
                    guard let self = self else { return }
                    self.delegate?.filtersVCDidSelectGeneration(generation: button)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            return cell
        case .clearAll:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") ?? ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
            if let button = cell as? ButtonCell{
                button.config()
                button.delegate = self
            }
            return cell
        }
    }
    
    
}

extension FiltersVC: ButtonCellDelegate {
    func didTapOnButton() {
        delegate?.filtersVCDidClearFilters()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }    
}
