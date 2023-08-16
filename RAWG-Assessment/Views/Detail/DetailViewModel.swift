//
//  DetailViewModel.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import Foundation

final class DetailViewModel: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    @Dependency(\.coreDataManager) var coreDataManager: CoreDataManager
    private weak var viewController: DetailController?
    
    private let gameID: Int
    
    @Published private(set) var gameDetail: Game? = nil
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    @Published private(set) var isFavorited: Bool?
    
    init(vc: DetailController, gameID: Int) {
        viewController = vc
        self.gameID = gameID
    }
    
    func getGameDetail() {
        Task {
            isLoading = true
            do {
                let retrievedGameDetail = try await webservice.request(gameId: gameID, responseType: Game.self)
                gameDetail = retrievedGameDetail
                checkIfIsFavorited()
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
    
    func checkIfIsFavorited() {
        if let savedGame = coreDataManager.findGame(byId: gameID) {
            isFavorited = true
        } else {
            isFavorited = false
        }
    }
    
    func addGameToFavorites() {
        guard let gameDetail else { return }
        coreDataManager.saveGame(gameDetail)
        checkIfIsFavorited()
    }
    
    func deleteGameFromFavorites() {
        coreDataManager.deleteGame(gameID)
        checkIfIsFavorited()
    }
}
