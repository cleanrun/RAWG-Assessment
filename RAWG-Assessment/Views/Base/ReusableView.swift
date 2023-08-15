//
//  ReusableView.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

