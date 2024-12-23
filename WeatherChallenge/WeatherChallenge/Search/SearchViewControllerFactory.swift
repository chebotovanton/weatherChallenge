//
//  SearchViewControllerFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

// WIP: Add a protocol?
final class SearchViewControllerFactory {
    func createViewController() -> UIViewController {
        let searchNavController = UINavigationController()
        let router = SearchRouter(
            navigationController: searchNavController,
            resultDetailsPageFactory: ResultDetailsPageFactory()
        )
        let viewModel = SearchViewModel(router: router)
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchNavController.viewControllers = [searchViewController]
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        return searchNavController
    }
}