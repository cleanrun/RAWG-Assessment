//
//  HomeController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class HomeController: BaseViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Game>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Game>
    
    private lazy var mainView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
        return searchController
    }()
    
    private var viewModel: HomeViewModel!
    private var dataSource: DataSource!
    private let imageDownloader = AsyncImageDownloader()

    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = HomeViewModel(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Games For You"
        addMainView(mainView: mainView)
        mainView.setTableViewDelegateAndRegisterCell(delegate: self, prefetchDataSource: self)
        
        dataSource = DataSource(tableView: mainView.listTableView, cellProvider: {
             tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier) as! GameCell
            cell.selectionStyle = .none
            cell.setData(item)
            
            if let downloadedImage = self.imageDownloader.downloadedImage(for: item.representedID) {
                cell.updateImage(downloadedImage)
                return cell
            }
            
            cell.updateImage(nil)
            if let backgroundImage = item.backgroundImage {
                self.imageDownloader.downloadAsync(item.representedID, imageURLString: backgroundImage) { image in
                    DispatchQueue.main.async {
                        guard cell.representedID == item.representedID else { return }
                        cell.updateImage(image)
                    }
                }
            }
            
            return cell
        })
        
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getGames()
    }
    
    override func setupBindings() {
        viewModel.$games.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupSnapshot(value)
        }.store(in: &disposables)
        
        viewModel.$errorState.receive(on: DispatchQueue.main).sink { value in
            if let value {
                print("Error: \(value)")
            }
        }.store(in: &disposables)
        
        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [unowned self] value in
            if viewModel.page == 1 {
                self.mainView.setLoadingState(value)
            } else {
                self.mainView.setLoadingState(false)
            }
        }.store(in: &disposables)
        
        viewModel.$searchQuery.debounce(for: 1, scheduler: DispatchQueue.main).sink { [unowned self] _ in
            self.viewModel.getGames()
        }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ value: [Game]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(value, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GameCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameID = viewModel.games[indexPath.row].id
        let detailVC = DetailController(gameID: gameID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.games.count == indexPath.row + 1 && viewModel.searchQuery == nil {
            viewModel.getGames()
        }
    }
}

extension HomeController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.games[indexPath.row]
            if let backgroundImage = item.backgroundImage {
                imageDownloader.downloadAsync(item.representedID, imageURLString: backgroundImage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.games[indexPath.row]
            imageDownloader.cancelDownload(item.representedID)
        }
    }
}

extension HomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchQuery(searchText)
    }
}
