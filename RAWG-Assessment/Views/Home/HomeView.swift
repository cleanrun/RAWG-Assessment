//
//  HomeView.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class HomeView: BaseView {
    
    private(set) lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubviews(listTableView, loadingIndicator)
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            listTableView.leftAnchor.constraint(equalTo: leftAnchor),
            listTableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setTableViewDelegateAndRegisterCell(delegate: UITableViewDelegate) {
        listTableView.delegate = delegate
        listTableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseIdentifier)
    }
    
    func setLoadingState(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        
        loadingIndicator.isHidden = !isLoading
        listTableView.isHidden = isLoading
    }
}
