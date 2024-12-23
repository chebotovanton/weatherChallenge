//
//  MainTabBarController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let searchViewControllerFactory: SearchViewControllerFactory
    
    init(
        searchViewControllerFactory: SearchViewControllerFactory
    ) {
        self.searchViewControllerFactory = searchViewControllerFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewController = self.searchViewControllerFactory.createViewController()
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        
        let favouritesViewController = UIViewController()
        favouritesViewController.tabBarItem.title = "Favourites"
        favouritesViewController.tabBarItem.image = UIImage(systemName: "heart")
        
        self.viewControllers = [searchNavController, favouritesViewController]
    }
}

// WIP: Add a protocol?
// WIP: Move to a separate class
final class SearchViewControllerFactory {
    func createViewController() -> UIViewController {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        return searchViewController
    }
}
