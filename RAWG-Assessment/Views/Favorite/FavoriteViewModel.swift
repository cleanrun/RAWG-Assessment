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
    @Dependency(\.coreDataManager) var coreDataManager: CoreDataManager
    private weak var viewController: FavoriteController?
    
    @Published private(set) var savedGames: [Game] = []
    
    init(vc: FavoriteController) {
        viewController = vc
    }
    
    func getSavedGames() {
        savedGames.removeAll()
        savedGames = coreDataManager.getAllGames()
    }
    
}
