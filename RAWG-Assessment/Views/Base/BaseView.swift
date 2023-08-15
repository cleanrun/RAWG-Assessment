//
//  BaseView.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

class BaseView: UIView {

    init() {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    func setupSubviews() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
