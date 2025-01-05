//
//  ResultDetailsPageFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class ResultDetailsPageFactory: ResultDetailsPageFactoryProtocol {
    private let currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol
    private let forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol
    private let forecastItemCellViewModelFactory: ForecastItemCellViewModelFactoryProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    init(
        currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol,
        forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol,
        forecastItemCellViewModelFactory: ForecastItemCellViewModelFactoryProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.currentWeatherCellViewModelFactory = currentWeatherCellViewModelFactory
        self.forecastCellViewModelFactory = forecastCellViewModelFactory
        self.forecastItemCellViewModelFactory = forecastItemCellViewModelFactory
        self.favoritesService = favoritesService
    }
    
    func createResultDetailsController(
        location: Location,
        locationDetailsRouterDelegate: LocationDetailsRouterDelegateProtocol
    ) -> UIViewController {
        let currentWeatherItem = CurrentWeatherTableItem(
            location: location,
            currentWeatherCellViewModelFactory: currentWeatherCellViewModelFactory
        )
        let forecastItem = ForecastTableItem(
            location: location,
            forecastCellViewModelFactory: forecastCellViewModelFactory,
            forecastItemCellViewModelFactory: forecastItemCellViewModelFactory
        )
        
        let router = LocationDetailsRouter(
            delegate: locationDetailsRouterDelegate
        )
        
        let viewModel = LocationDetailsViewModel(
            location: location,
            weatherItems: [
                currentWeatherItem,
                forecastItem
            ],
            router: router,
            favoritesService: favoritesService
        )
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        viewController.title = location.name
        viewController.view.backgroundColor = .white
        
        router.presentedViewController = viewController
        
        return viewController
    }
}
