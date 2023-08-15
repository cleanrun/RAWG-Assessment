//
//  HomeViewModel.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation
import Combine

final class HomeViewModel: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: HomeController?
    
    private var allGames = [Game]()
    @Published private(set) var games = [Game]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    @Published private(set) var searchQuery: String? = nil
    private(set) var page: Int = 0
    
    init(vc: HomeController) {
        viewController = vc
    }
    
    func getGames() {
        guard page != 10, errorState == nil else { return }
        page += 1
        Task {
            isLoading = true
            do {
                let retrievedGames = try await webservice.request(page: page, searchQuery: searchQuery, responseType: ListResponse<Game>.self)
                if page == 1 {
                    allGames = retrievedGames.results
                } else {
                    allGames += retrievedGames.results
                }
                games = allGames
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
    
    func setSearchQuery(_ query: String) {
        searchQuery = query.isEmpty ? nil : query
        page = 0
    }
    
}
