//
//  ResultDetailsPageFactory.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

final class ResultDetailsPageFactory: ResultDetailsPageFactoryProtocol {
    private let weatherLoadingService: WeatherLoadingServiceProtocol
    
    init(
        weatherLoadingService: WeatherLoadingServiceProtocol
    ) {
        self.weatherLoadingService = weatherLoadingService
    }
    
    func createResultDetailsController(searchResult: SearchResult) -> UIViewController {
        
        let currentWeatherItem = CurrentWeatherTableItem(
            location: searchResult,
            weatherLoadingService: weatherLoadingService
        )
        let viewModel = LocationDetailsViewModel(
            location: searchResult,
            weatherItems: [
                currentWeatherItem
            ]
        )
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        viewController.title = searchResult.name
        viewController.view.backgroundColor = .white
        
        return viewController
    }
}
