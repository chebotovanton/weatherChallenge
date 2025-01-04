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
    private let favoritesService: FavoritesServiceProtocol
    
    init(
        currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol,
        forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol,
        favoritesService: FavoritesServiceProtocol
    ) {
        self.currentWeatherCellViewModelFactory = currentWeatherCellViewModelFactory
        self.forecastCellViewModelFactory = forecastCellViewModelFactory
        self.favoritesService = favoritesService
    }
    
    func createResultDetailsController(Location: Location) -> UIViewController {
        let currentWeatherItem = CurrentWeatherTableItem(
            location: Location,
            currentWeatherCellViewModelFactory: currentWeatherCellViewModelFactory
        )
        let forecastItem = ForecastTableItem(
            location: Location,
            forecastCellViewModelFactory: forecastCellViewModelFactory
        )
        
        let router = LocationDetailsRouter()
        
        let viewModel = LocationDetailsViewModel(
            location: Location,
            weatherItems: [
                currentWeatherItem,
                forecastItem
            ],
            router: router,
            favoritesService: favoritesService
        )
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        viewController.title = Location.name
        viewController.view.backgroundColor = .white
        
        router.presentedViewController = viewController
        
        return viewController
    }
}
