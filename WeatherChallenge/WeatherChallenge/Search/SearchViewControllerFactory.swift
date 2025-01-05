//
//  SearchViewControllerFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

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
        
        let currentWeatherUrlFormatter = UrlFormatter(
            urlFormat: "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@",
            apiKeyProvider: apiKeyProvider
        )
        let currentWeatherCellViewModelFactory = CurrentWeatherCellViewModelFactory(
            urlFormatter: currentWeatherUrlFormatter,
            urlSession: urlSession,
            // WIP: Share this tempFormatter
            tempFormatter: TemperatureFormatter()
        )
        
        let favoritesService = FavoritesService(
            userDefaults: UserDefaults.standard
        )
        
        let router = SearchRouter(
            navigationController: searchNavController,
            resultDetailsPageFactory: ResultDetailsPageFactory(
                currentWeatherCellViewModelFactory: currentWeatherCellViewModelFactory,
                forecastCellViewModelFactory: forecastCellViewModelFactory,
                favoritesService: favoritesService
            )
        )
        
        let viewModel = SearchViewModel(
            router: router,
            searchService: LocationSearchService(
                apiKeyProvider: apiKeyProvider,
                resultsLimit: 10,
                urlSession: urlSession
            ),
            favoritesService: favoritesService
        )
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchNavController.viewControllers = [searchViewController]
        
        return searchNavController
    }
}

// TODO: This class can stay on the app level, while all the viewModel, viewController and router classes should be moved to a separate module
