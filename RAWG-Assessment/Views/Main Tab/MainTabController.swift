//
//  MainTabController.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import UIKit

final class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        tabBar.tintColor = MAIN_COLOR
        
        viewControllers = [
            createNavController(for: HomeController(), title: "Home", activeIcon: "house.fill", inactiveIcon: "house"),
            createNavController(for: FavoriteController(), title: "Favorite", activeIcon: "heart.fill", inactiveIcon: "heart"),
        ]
        
        tabBar.isTranslucent = true
    }

    private func createNavController(for vc: UIViewController, title: String, activeIcon: String, inactiveIcon: String) -> UINavigationController {
        let activeImageIcon = UIImage(systemName: activeIcon)
        let inactiveImageIcon = UIImage(systemName: inactiveIcon)
        let tabBarItem = UITabBarItem(title: title, image: inactiveImageIcon, selectedImage: activeImageIcon)
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = MAIN_COLOR
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.standardAppearance = barAppearance
        navController.navigationBar.scrollEdgeAppearance = barAppearance
        navController.tabBarItem = tabBarItem
        return navController
    }

}
