//
//  BaseViewController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit
import Combine

protocol BaseVMProtocol: AnyObject {
    var webservice: Webservice { get }
}

class BaseViewController: UIViewController {
    
    var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {}
    
    func addSubviewAndConstraints(view: UIView, constraints: [NSLayoutConstraint]) {
        self.view.addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
    
    func addMainView(mainView: BaseView) {
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

typealias ViewController = BaseViewController
typealias ViewModel = ObservableObject & BaseVMProtocol
