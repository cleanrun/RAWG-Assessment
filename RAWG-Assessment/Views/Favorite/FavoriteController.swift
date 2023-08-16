//
//  FavoriteController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

class FavoriteController: BaseViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Game>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Game>

    private lazy var mainView: FavoriteView = {
        let view = FavoriteView()
        return view
    }()
    
    private var viewModel: FavoriteViewModel!
    private var dataSource: DataSource!
    private let imageDownloader = AsyncImageDownloader()

    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = FavoriteViewModel(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Favorite Games"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSavedGames()
    }
    
    override func setupBindings() {
        viewModel.$savedGames.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupSnapshot(value)
        }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ value: [Game]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(value, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension FavoriteController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        GameCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameID = viewModel.savedGames[indexPath.row].id
        let detailVC = DetailController(gameID: gameID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoriteController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.savedGames[indexPath.row]
            if let backgroundImage = item.backgroundImage {
                imageDownloader.downloadAsync(item.representedID, imageURLString: backgroundImage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.savedGames[indexPath.row]
            imageDownloader.cancelDownload(item.representedID)
        }
    }
}
