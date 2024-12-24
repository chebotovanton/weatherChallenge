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
        let forecastUrlFormatter = UrlFormatter(
            urlFormat: "https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%@",
            apiKeyProvider: apiKeyProvider
        )
                
        let forecastCellViewModelFactory = ForecastCellViewModelFactory(
            urlFormatter: forecastUrlFormatter,
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
