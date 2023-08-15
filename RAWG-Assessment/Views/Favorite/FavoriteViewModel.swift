//
//  FavoriteViewModel.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation
import Combine

final class FavoriteViewModel: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: FavoriteController?
    
    init(vc: FavoriteController) {
        viewController = vc
    }
    
}
