//
//  FavoriteController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

class FavoriteController: BaseViewController {

    private lazy var mainView: FavoriteView = {
        let view = FavoriteView()
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Favorite Games"
        addMainView(mainView: mainView)
    }

}
