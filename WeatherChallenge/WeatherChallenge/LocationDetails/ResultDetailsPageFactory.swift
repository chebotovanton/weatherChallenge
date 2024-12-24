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
    
    func createResultDetailsController(searchResult: SearchResult) -> UIViewController {
        
        let currentWeatherItem = CurrentWeatherTableItem(
            location: searchResult,
            currentWeatherCellViewModelFactory: currentWeatherCellViewModelFactory
        )
        let forecastItem = ForecastTableItem(
            location: searchResult,
            forecastCellViewModelFactory: forecastCellViewModelFactory
        )
        
        let viewModel = LocationDetailsViewModel(
            location: searchResult,
            weatherItems: [
                currentWeatherItem,
                forecastItem
            ]
        )
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        viewController.title = searchResult.name
        viewController.view.backgroundColor = .white
        
        return viewController
    }
}
