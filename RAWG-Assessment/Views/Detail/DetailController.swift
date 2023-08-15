//
//  DetailController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import UIKit

final class DetailController: BaseViewController {
    private lazy var mainView: DetailView = {
        let view = DetailView()
        return view
    }()
    
    private var viewModel: DetailViewModel!
    
    init(gameID: Int) {
        super.init(nibName: nil, bundle: nil)
        viewModel = DetailViewModel(vc: self, gameID: gameID)
    }
    
    override func loadView() {
        super.loadView()
        title = "Detail"
        navigationItem.backBarButtonItem?.title = ""
        addMainView(mainView: mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getGameDetail()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.$gameDetail.receive(on: DispatchQueue.main).sink { [unowned self] value in
            if let value {
                self.mainView.setupData(value)
            }
        }.store(in: &disposables)
        
        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.mainView.setLoadingState(value)
        }.store(in: &disposables)
    }
}
