//
//  DetailViewModel.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import Foundation

final class DetailViewModel: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: DetailController?
    
    private let gameID: Int
    
    @Published private(set) var gameDetail: Game? = nil
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    
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
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}
