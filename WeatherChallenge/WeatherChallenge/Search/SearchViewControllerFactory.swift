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
        
        let urlSession = URLSession(configuration: .default)
        let apiKeyProvider = ApiKeyProvider()
                
        let forecastCellViewModelFactory = ForecastCellViewModelFactory(
            apiKeyProvider: apiKeyProvider,
            urlSession: urlSession
        )
        
        let router = SearchRouter(
            navigationController: searchNavController,
            resultDetailsPageFactory: ResultDetailsPageFactory(
                weatherLoadingService: WeatherLoadingService(urlSession: urlSession),
                forecastCellViewModelFactory: forecastCellViewModelFactory
            )
        )
        
        let viewModel = SearchViewModel(
            router: router,
            searchService: LocationSearchService(
                resultsLimit: 10,
                urlSession: urlSession
            )
        )
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchNavController.viewControllers = [searchViewController]
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        return searchNavController
    }
}

// TODO: This class can stay on the app level, while all the viewModel, viewController and router classes should be moved to a separate module

final class ApiKeyProvider: ApiKeyProviderProtocol {
    var apiKey: String = "3e5afd29dd22c6c30c3f02832b405045"
}
