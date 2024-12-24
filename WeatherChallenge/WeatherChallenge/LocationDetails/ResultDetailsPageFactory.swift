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
    
    init(
        currentWeatherCellViewModelFactory: CurrentWeatherCellViewModelFactoryProtocol,
        forecastCellViewModelFactory: ForecastCellViewModelFactoryProtocol
    ) {
        self.currentWeatherCellViewModelFactory = currentWeatherCellViewModelFactory
        self.forecastCellViewModelFactory = forecastCellViewModelFactory
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
        
        let viewModel = LocationDetailsViewModel(
            location: Location,
            weatherItems: [
                currentWeatherItem,
                forecastItem
            ]
        )
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        viewController.title = Location.name
        viewController.view.backgroundColor = .white
        
        return viewController
    }
}
