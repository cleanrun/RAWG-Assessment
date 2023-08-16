//
//  FavoriteView.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class FavoriteView: BaseView {
    private(set) lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubviews(listTableView)
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            listTableView.leftAnchor.constraint(equalTo: leftAnchor),
            listTableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func setTableViewDelegateAndRegisterCell(delegate: UITableViewDelegate, prefetchDataSource: UITableViewDataSourcePrefetching) {
        listTableView.delegate = delegate
        listTableView.prefetchDataSource = prefetchDataSource
        listTableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseIdentifier)
    }
}
