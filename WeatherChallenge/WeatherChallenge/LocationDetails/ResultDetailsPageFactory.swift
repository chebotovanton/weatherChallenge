//
//  ResultDetailsPageFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class ResultDetailsPageFactory: ResultDetailsPageFactoryProtocol {
    private let weatherLoadingService: WeatherLoadingServiceProtocol
    private let forecastLoadingService: ForecastLoadingServiceProtocol
    
    init(
        weatherLoadingService: WeatherLoadingServiceProtocol,
        forecastLoadingService: ForecastLoadingServiceProtocol
    ) {
        self.weatherLoadingService = weatherLoadingService
        self.forecastLoadingService = forecastLoadingService
    }
    
    func createResultDetailsController(searchResult: SearchResult) -> UIViewController {
        
        let currentWeatherItem = CurrentWeatherTableItem(
            location: searchResult,
            weatherLoadingService: weatherLoadingService
        )
        let forecastItem = ForecastTableItem(
            location: searchResult,
            forecastLoadingService: forecastLoadingService
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
